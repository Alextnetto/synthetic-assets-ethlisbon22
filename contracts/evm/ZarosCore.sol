// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "chainlink/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/IzUSD.sol";

contract ZarosCore {
    AggregatorV3Interface internal priceFeedETH;
    IzUSD internal immutable zUSD;
    /// @dev collateralRatio / 10000 Ex.: 30000 = 300%
    uint256 public collateralRatio;
    uint256 public immutable collateralDivisor = 1e5;

    constructor(address zUSDAddress) {
        collateralRatio = 3 * 1e5;
        priceFeedETH = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        zUSD = IzUSD(zUSDAddress);
    }

    function getEthPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeedETH.latestRoundData();
        return price;
    }

    function mint(uint256 amount, uint256 collateralAmount)
        public
        returns (bool)
    {
        uint256 maxMintAmount = (collateralAmount * 1e5) / collateralRatio;
        require(maxMintAmount >= amount, "ZarosCore: Insuficient collateral");
        return zUSD.mint(msg.sender, amount);
    }
}
