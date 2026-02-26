// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    address payable public immutable owner;
    address public priceFeed;
    uint256 public amount;

    address[] public funders;
    mapping(address => uint) public addressToAmountFunded;

    constructor(address _priceFeed, uint256 _amount) {
        owner = payable(msg.sender);
        priceFeed = _priceFeed;
        amount = _amount * 1e18;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(priceFeed) >= amount,
            "You need to spend more ETH!"
        );
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
        for (uint256 i = 0; i < funders.length; i++) {
            addressToAmountFunded[funders[i]] = 0;
        }
        funders = new address[](0);
    }
}