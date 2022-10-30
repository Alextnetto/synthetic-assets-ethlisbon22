// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "./interfaces/IzUSD.sol";

contract ZUSD is ERC20, IzUSD {
    mapping(address => bool) private minters;
    address private immutable owner;

    constructor() ERC20("Zaros USD", "zUSD") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this");
        _;
    }

    modifier onlyMinter() {
        require(minters[msg.sender], "Address not allowed to mint");
        _;
    }

    function setMinter(address minter, bool enableMinting) public onlyOwner {
        minters[minter] = enableMinting;
    }

    function mint(address to, uint256 amount) public onlyMinter returns (bool) {
        _mint(to, amount);
        return true;
    }
}
