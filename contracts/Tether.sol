// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 
contract Tether is ERC20{
    constructor() ERC20("JPYC", "JPYC"){
        _mint(msg.sender,100000000*10**18);
        _mint(0x748Aa081b5cb78968c584aF8c53440b5d59a6Fe5, 100000000*10**18);
        _mint(0xE18E5dc6D0e254cAb81240Afa302f1bD4c0c8F5F, 100000000*10**18);
    }
}
