// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../contracts/evm/SyntheticMint.sol";
import "../../contracts/evm/zUSD.sol";

contract SyntheticMintTest is Test {
    SyntheticMint public syntheticMint;
    ZUSD public zUSD;
    address owner = address(0x1);
    address user = address(0x2);

    function setUp() public {
        vm.label(owner, "owner");
        vm.label(user, "user");
        vm.startPrank(owner);

        zUSD = new ZUSD();
        syntheticMint = new SyntheticMint(address(zUSD));

        zUSD.setMinter(address(syntheticMint), true);
        vm.stopPrank();
    }

    function testMintZUSD() public {
        vm.startPrank(user);
        uint256 amountToMint = 100;

        syntheticMint.mint(amountToMint);

        assertEq(amountToMint, zUSD.balanceOf(user));
        vm.stopPrank();
    }
}
