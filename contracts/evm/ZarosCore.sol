// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "chainlink/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/IzUSD.sol";
import "forge-std/Test.sol";

contract ZarosCore {
    AggregatorV3Interface internal priceFeedETH;
    IzUSD internal immutable zUSD;
    /// @dev collateralRatio / 10000 Ex.: 30000 = 300%
    uint256 public collateralRatio;
    uint256 public immutable collateralDecimals = 5;

    constructor(address zUSDAddress) {
        collateralRatio = 2 * 10**collateralDecimals;
        priceFeedETH = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        zUSD = IzUSD(zUSDAddress);
    }

    /// @dev Get Ether value in zUSD based on ether provided
    /// @param ethAmount Ether amount provided with 18 decimals
    /// @return price value of Ether provided in zUSD with 18 decimals
    function getEthValue(uint256 ethAmount) public view returns (uint256) {
        uint256 ORACLE_DECIMALS = 1e8;
        (, int256 price, , , ) = priceFeedETH.latestRoundData();

        return ((ethAmount) * uint256(price)) / ORACLE_DECIMALS;
    }

    function mint(uint256 amount) public payable returns (bool) {
        uint256 collateralAmount = getEthValue(msg.value);

        uint256 maxMintAmount = (collateralAmount * 10**collateralDecimals) /
            collateralRatio;

        console.logUint(maxMintAmount);
        console.logUint(amount);
        require(maxMintAmount >= amount, "ZarosCore: Insuficient collateral");
        return zUSD.mint(msg.sender, amount);
    }
}
