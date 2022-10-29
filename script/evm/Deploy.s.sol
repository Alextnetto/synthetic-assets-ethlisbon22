// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../contracts/evm/SyntheticMint.sol";
import "../../contracts/evm/zUSD.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.broadcast(deployerPrivateKey);

        ZUSD zUSD = new ZUSD();
        SyntheticMint syntheticMint = new SyntheticMint(address(zUSD));

        vm.stopBroadcast();
    }
}
