// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "chainlink/v0.8/interfaces/AggregatorV3Interface.sol";

contract SyntheticMint {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
    }

    function getEthPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    function mint(uint256) public {}
}
