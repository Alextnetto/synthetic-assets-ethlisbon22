// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../contracts/evm/ZarosCore.sol";
import "../../contracts/evm/zUSD.sol";

contract ZarosCoreTest is Test {
    ZarosCore public zarosCore;
    ZUSD public zUSD;
    address owner = address(0x1);
    address user = address(0x2);

    function setUp() public {
        vm.label(owner, "owner");
        vm.label(user, "user");
        vm.startPrank(owner);

        zUSD = new ZUSD();
        zarosCore = new ZarosCore(address(zUSD));

        zUSD.setMinter(address(zarosCore), true);
        vm.stopPrank();
    }

    function testMintZUSD() public {
        vm.startPrank(user);
        uint256 amountToMint = 10000;
        uint256 collateralAmount = (zarosCore.collateralRatio() *
            amountToMint) / 100;

        console.logUint(collateralAmount);

        zarosCore.mint(amountToMint, collateralAmount);

        assertEq(amountToMint, zUSD.balanceOf(user));
        vm.stopPrank();
    }

    function testMintZUSDWithInsuficientCollateral() public {
        vm.startPrank(user);
        uint256 amountToMint = 100000;
        uint256 collateralAmount = (zarosCore.collateralRatio() *
            amountToMint) /
            100000 -
            1;

        vm.expectRevert("ZarosCore: Insuficient collateral");
        zarosCore.mint(amountToMint, collateralAmount);

        assertEq(0, zUSD.balanceOf(user));
        vm.stopPrank();
    }
}
