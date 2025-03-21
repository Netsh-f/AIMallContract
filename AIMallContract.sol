// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./ModelLicenseNFT.sol";

contract AIMallContract {
    using SafeERC20 for IERC20;
    IERC20 private immutable amtToken;
    ModelLicenseNFT private immutable mltToken;

    constructor(address amtTokenAddress, address mltTokenAddress) {
        amtToken = IERC20(amtTokenAddress);
        mltToken = ModelLicenseNFT(mltTokenAddress);
    }

    function purchase(string memory imageUri, address creator, uint256 amount) public {
        uint256 allowance = amtToken.allowance(msg.sender, address(this));
        require(allowance >= amount, "===AIMallContract: insufficient AMT allowance===");

        amtToken.safeTransferFrom(msg.sender, creator, amount);

        uint256 tokenId = mltToken.awardItem(creator, imageUri);
        mltToken.safeTransferFrom(creator, msg.sender, tokenId);
    }
}