// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


error NotOwner();

contract GetMeFund {
    AggregatorV3Interface internal immutable dataFeed;

    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5;

    address[] public funders;
    mapping (address funders => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        i_owner = msg.sender;
    }

    function getPrice() public view returns (uint256) {
        (, int256 price, , , ) = dataFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getTotalAmount(uint256 _ethInWei) public view returns (uint256) {
        uint256 ethToUSD = (getPrice() * _ethInWei)/1e18;
        return ethToUSD;
    }

    function fund() public payable {
        require(getTotalAmount(msg.value) > MINIMUM_USD, "Ether sent must be greater than 5 USD");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() external onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++)
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Fund withdrawal failed");
    }

    modifier onlyOwner() {
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }
}
