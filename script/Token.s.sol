// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {Script, console} from "forge-std/Script.sol";

interface IToken {
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address _owner) external view returns (uint256);
}

contract Tokensolution is Script {
    function run() external {
        address inst = 0x9a8cbb365572D2306b6A414d7Ca11b209B4b358a;
        vm.startBroadcast();

        IToken tkn = IToken(inst);
        console.log(tkn.balanceOf(msg.sender));
        console.log(tkn.balanceOf(address(0x1)));

        tkn.transfer(address(0x1), 21);
        
        console.log(tkn.balanceOf(msg.sender));
        console.log(tkn.balanceOf(address(0x1)));
        
        vm.stopBroadcast();
    }
}
