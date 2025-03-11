// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./Struct.sol";
import "./Error.sol";

contract AIMallContract {
    address private immutable owner;
    IERC20 private immutable usdtToken;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert AIMallNotOwner();
        }
        _;
    }

    constructor(address usdtTokenAddress) {
        owner = msg.sender;
        usdtToken = IERC20(usdtTokenAddress);
    }

    mapping (uint256 => Model) private id_model;

    mapping (address => uint256[]) private userAddress_modelIds;

    function deposit(uint256 amount) public {
        bool success = usdtToken.transferFrom(msg.sender, address(this), amount);
        if (!success) {
            revert TransferFailed();
        }
    }
}