// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../contracts/evm/SyntheticMint.sol";

contract SyntheticMintTest is Test {
    SyntheticMint public syntheticMint;

    function setUp() public {
        syntheticMint = new SyntheticMint();
    }

    function testIncrement() public view {
        //int256 price = syntheticMint.getEthPrice();
        int256 price = 1;
        console.log("Price");
        console.logInt(price);
    }
}
