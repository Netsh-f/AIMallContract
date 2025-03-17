// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./Struct.sol";
import "./Error.sol";

contract AIMallContract {
    using Counters for Counters.Counter;
    using SafeERC20 for IERC20;

    address private immutable owner;
    IERC20 private immutable amtToken;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert AIMallNotOwner();
        }
        _;
    }

    constructor(address amtTokenAddress) {
        owner = msg.sender;
        amtToken = IERC20(amtTokenAddress);
    }

    // Model
    mapping (uint256 => Model) private idModelMap;
    mapping (address => uint256[]) private addressModelIdsMap;
    Counters.Counter private modelIdCounter;

    function uploadModel(string memory name, string memory imageURI, uint256 price) public {
        require(price >= 0, "Price must be greater than zero");
        modelIdCounter.increment();
        uint256 id = modelIdCounter.current();
        idModelMap[id] = Model(name, imageURI, price, msg.sender);
        addressModelIdsMap[msg.sender].push(id);
    }

    function getModelById(uint256 id) public view returns (Model memory) {
        require(idModelMap[id].owner != address(0), "Model does not exist");
        return idModelMap[id];
    }

    function purchaseModel(uint256 id, uint256 amount) public {
        Model storage model = idModelMap[id];
        require(model.owner != address(0), "Model does not exist");
        require(amount > 0, "Amount must be greater than zero");

        uint256 totalPrice = model.price * amount;
        amtToken.safeTransferFrom(msg.sender, model.owner, totalPrice);
    }
}