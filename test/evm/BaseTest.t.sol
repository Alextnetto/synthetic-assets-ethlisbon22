// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "chainlink/v0.8/interfaces/AggregatorV3Interface.sol";

library OracleHelper {
    /// @notice The ```setPrice``` function uses a numerator and denominator value to set a price using the number of decimals from the oracle itself
    /// @dev Remember the units here, quote per asset i.e. USD per ETH for the ETH/USD oracle
    /// @param _oracle The oracle to mock
    /// @param numerator The numerator of the price
    /// @param denominator The denominator of the price
    /// @param vm The vm from forge
    function setPrice(
        AggregatorV3Interface _oracle,
        uint256 oracleDecimals,
        uint256 numerator,
        uint256 denominator,
        Vm vm
    ) internal {
        console.log("setPrice(): ------------------");
        console.log(address(_oracle));
        vm.mockCall(
            address(_oracle),
            abi.encodeWithSelector(
                AggregatorV3Interface.latestRoundData.selector
            ),
            abi.encode(
                uint80(0),
                int256((numerator * 10**oracleDecimals) / denominator),
                0,
                0,
                uint80(0)
            )
        );
        vm.warp(block.timestamp + 15);
        vm.roll(block.number + 1);
    }
}

contract BaseTest is Test {
    using OracleHelper for AggregatorV3Interface;
    address internal constant CHAINLINK_ETH_USD =
        0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e;
    AggregatorV3Interface public oracle =
        AggregatorV3Interface(CHAINLINK_ETH_USD);
}
