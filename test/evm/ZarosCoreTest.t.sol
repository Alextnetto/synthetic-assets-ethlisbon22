// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./BaseTest.t.sol";
import "../../contracts/evm/ZarosCore.sol";
import "../../contracts/evm/zUSD.sol";

contract ZarosCoreTest is BaseTest {
    using OracleHelper for AggregatorV3Interface;

    ZarosCore public zarosCore;
    ZUSD public zUSD;

    uint256 ethPriceExpected = 2000;
    address owner = address(0x1);
    address user = address(0x2);

    function setUp() public {
        vm.label(owner, "owner");
        vm.label(user, "user");
        vm.deal(owner, 10 ether);
        vm.deal(user, 10 ether);
        vm.startPrank(owner);

        zUSD = new ZUSD();
        zarosCore = new ZarosCore(address(zUSD));

        zUSD.setMinter(address(zarosCore), true);
        vm.stopPrank();
        oracle.setPrice(8, ethPriceExpected, 1, vm);
    }

    function testEthPrice() public {
        uint256 ethPriceFromOracle = zarosCore.getEthValue(1 ether);
        assertEq(ethPriceFromOracle, ethPriceExpected * 10**zUSD.decimals());
    }

    // TODO: ceil on division, gives error if eth price = 3000
    function testMintZUSD() public {
        vm.startPrank(user);
        uint256 amountToMint = 1000 * 10**zUSD.decimals();

        uint256 minCollateralAmount = (amountToMint *
            zarosCore.collateralRatio()) /
            (ethPriceExpected * 10**zarosCore.collateralDecimals());

        zarosCore.mint{value: minCollateralAmount}(amountToMint);

        assertEq(zUSD.balanceOf(user), amountToMint);
        vm.stopPrank();
    }

    function testTryMintZUSDWithInsuficientCollateral() public {
        vm.startPrank(user);
        uint256 amountToMint = 100000;
        uint256 minCollateralAmount = (amountToMint *
            zarosCore.collateralRatio()) /
            (ethPriceExpected * 10**zarosCore.collateralDecimals());

        vm.expectRevert("ZarosCore: Insuficient collateral");

        zarosCore.mint{value: minCollateralAmount - 1}(amountToMint);

        assertEq(0, zUSD.balanceOf(user));
        vm.stopPrank();
    }
}
