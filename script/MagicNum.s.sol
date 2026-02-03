// SPDX-License_identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import "../src/MagicNum.sol";

contract MagicNumSolution is Script {
    function run() external {
        vm.startBroadcast();
        MagicNum instance = MagicNum(0xACc5677BDb0b379Db1eeBb0133F6c5b3c7fbE72A);
        address solver;
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        assembly {
            solver := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        instance.setSolver(solver);
        vm.stopBroadcast();
    }
}


/*
Run time code return 255
60ff60005260206000f3
// Store 255 to memory

mstore(p, v) store v at memory p to p + 32

PUSH1 0xff
PUSH1 0
MSTORE

// Return 32 bytes from memory
return(p, s) end execution and return data from memory p to p + s

PUSH1 0x20
PUSH1 0
RETURN

Creation code - return runtime code
69602a60005260206000f3600052600a6016f3

// Store run time code to memory
PUSH10 0X60ff60005260206000f3
PUSH1 0
MSTORE

// Return 10 bytes from memory starting at offset 22
PUSH1 0x0a
PUSH1 0x16
RETURN
*/