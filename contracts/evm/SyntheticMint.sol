// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "chainlink/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/IzUSD.sol";

contract SyntheticMint {
    AggregatorV3Interface internal priceFeed;
    IzUSD internal immutable zUSD;

    constructor(address zUSDAddress) {
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        zUSD = IzUSD(zUSDAddress);
    }

    function getEthPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    function mint(uint256 amount) public returns (bool) {
        return zUSD.mint(msg.sender, amount);
    }
}
