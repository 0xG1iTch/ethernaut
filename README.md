# Ethernaut Notes

---
## 0. Fallback

**Idea:** Badly designed fallback/receive logic + ownership change = easy takeover.

**Notes:**
- Fallback/receive functions run when:
  - ETH is sent with **no data**, or
  - A non‑existent function is called.
- Sending a small contribution then sending ETH directly to the contract triggers the fallback and updates `owner` to `msg.sender`.
- Once owner, `withdraw()` lets you drain the contract.
- Never put **privileged logic** like ownership changes in fallback/receive functions.

---

## 1. Fallout

**Idea:** Old‑style constructors (name = contract name) can be broken by typos.

**Notes:**
- In old Solidity constructors were functions with the same name as the contract.
- The function is named `Fal1out`, so it is not a constructor, just a public function.
- Anyone can call `Fal1out()` and become `owner`.
- Use the modern `constructor` keyword.

---

## 2. Coin Flip

**Idea:** Pseudo‑randomness based on predictable chain data is not random.

**Notes:**
- The contract uses `blockhash(block.number - 1)` and a known `FACTOR` to compute the “random” flip.
- Any contract in the same block can compute the exact same value and always guess correctly.
- Never use on‑chain predictable values (blockhash, timestamp, etc.) alone for randomness.

---

## 3. Telephone

**Idea:** `tx.origin` is dangerous for auth; use `msg.sender` instead.

**Notes:**
- `tx.origin` is always the **original EOA** that started the transaction.
- If a contract checks `if (tx.origin == owner)`, an attacker can:
  - Trick the owner into calling the attacker’s contract.
  - The attacker’s contract then calls the target; `tx.origin` is still the owner, but `msg.sender` is attacker.
- You can use an intermediate contract to call `changeOwner` and bypass the check.
- Never use `tx.origin` for authorization; always use `msg.sender`.

---

## 4. Token

**Idea:** Integer underflow/overflow in older Solidity can break logic.

**Notes:**
- In Solidity <0.8, `uint` arithmetic silently wraps on overflow/underflow.
- `transfer` subtracts from `balances[msg.sender]` without checks; sending more than your balance underflows to a huge number.
- That gives you a massive balance and breaks the token’s accounting.
  - In old versions: use SafeMath.
  - In modern Solidity: rely on built‑in checked arithmetic.

---

## 5. Delegation

**Idea:** `delegatecall` executes other contract’s code in your storage context.

**Notes:**
- `delegatecall` preserves: `msg.sender` and `msg.value`, but uses the calling contract’s storage layout.
- Delegation` uses `delegatecall` to `Delegate`, and `Delegate` has a function that writes to `owner`.
- Calling that function via `delegatecall` makes `Delegation.owner` become your address.
  - `delegatecall` is powerful and dangerous.
  - Storage layout between proxy/logic contracts must match.
  - Never delegatecall to untrusted or user‑controlled addresses.

---

## 6. Force

**Idea:** You can force ETH into a contract even if it has no `receive` / `fallback` and no payable functions.

**Notes:**
- `selfdestruct(address)` sends the contract’s entire balance to any address, without calling any function on the target.
- Because of that, a contract cannot guarantee `address(this).balance == 0`.
- Never base logic or invariants on "this contract can never receive ETH" or on the exact value of `address(this).balance`.

---

## 7. Vault

**Idea:** `private` in Solidity ≠ secret on-chain.

**Notes:**
- `private` only restricts access from other Solidity contracts, not from people reading the blockchain.
- All contract storage (state variables) is publicly readable via RPC (`cast storage <addr> <slot>`).
- You can recover a `bytes32` "password" stored as a private state variable by reading the correct storage slot and then calling the unlock function with that value.
- Don't store secrets on-chain

---

## 3. King

**Idea:** Denial of Service (DoS) via forcing a refund to always fail.

**Notes:**
- The contract calls `payable(king).transfer(msg.value)` when a new king is crowned.
- If `king` is a contract that cannot receive ETH (no `receive` / `fallback`, or it reverts), then `transfer` fails, and the whole transaction reverts.
- By making such a contract the king once, no one can become king anymore => permanent DoS.
- Never depend on always being able to send ETH to an arbitrary `address`:
  - The address might be a contract that reverts on receive.
  - Refund patterns that blindly `transfer` to user addresses can be DoS’d.

---

## 4. Reentrance

**Idea:** Reentrancy when you send ETH before updating balances.

**Notes:**
- Vulnerable pattern:
  ```solidity
  if (balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value: _amount}("");
      balances[msg.sender] -= _amount;
  }
  
- If `msg.sender` is a contract, its `receive` can call `withdraw` again while the balance is still high.
- This repeated re‑entering drains the contract.
- update storage before external calls.
- Or use a reentrancy guard.

---

## 10. Elevator

**Idea:** External callbacks through interfaces can lie and be stateful.

**Key points:**
- `goTo` calls `building.isLastFloor(_floor)` twice and assumes consistent behavior.
- The attack contract implements `isLastFloor` to:
  - Return `false` the first time so `if (!false)` passes.
  - Return `true` the second time so `top` becomes true.
- Interfaces only fix the function signature, not the behavior.
- Don’t rely on external contracts behaving “honestly” or consistently

---
## 11. Privacy

**Idea:** Packed storage

**Notes:**
- State variables are packed into 32‑byte slots in declaration order.
- Fixed arrays like `bytes32[3]` get one slot per element (slot 3, 4, 5).
- `unlock(bytes16)` needs first 16 bytes of `data[2]` (slot 5).
- Use `vm.load(instance, 5)` to read slot 5, then `bytes16(slotValue)`.
- All storage is readable, reconstruct private data with storage layout knowledge.

---
## 12. GatekeeperOne

**Idea:** Three gates must be bypassed simultaneously. contract caller - gas condition - bit manipulation.

**Notes:**
- Gate 1: `msg.sender != tx.origin` -> call from contract
- Gate 2: `gasleft() % 8191 == 0` -> brute force gas with `call{gas: ...}`.
- Gate 3: Craft `bytes8` where:
  - Bits 0-15 = lowest 16 bits of `tx.origin`
  - Bits 16-31 = `0x0000`
  - Bits 32-63 = non-zero (set bit 32 to 1)
- `uint32(key) == uint16(key)` requires bits 16-31 = 0.
- Brute force small gas offsets until one satisfies the modulo condition.

---
## 13. GatekeeperTwo

**Idea:** Constructor extcodesize trick + XOR

**Notes:**
- Gate 1: `msg.sender != tx.origin` -> call from contract.
- Gate 2: `extcodesize(caller()) == 0` -> call `enter()` from constructor because code not deployed yet.
- Gate 3: `hash(msg.sender) ^ gateKey == 0xFFFFFFFFFFFFFFFF`
  - simple XOR: if `A ^ K = M`, then `K = A ^ M`
  - `gateKey = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max`
- constructor calls `enter()` automatically

---
## 14. NaughtCoin

**Idea:** ERC20 has multiple ways to move tokens

**Notes:**
- ERC20 has `transfer`, direct transfer. and `approve` + `transferFrom`, delegated.
- the contract only overrode `transfer` with timelock, `approve` + `transferFrom` still works.
- `approve(spender, amount)` gives permission to spend tokens
- `transferFrom(from, to, amount)` spends that permission as `spender`
- `player.approve(attacker, balance)` + `attacker.transferFrom(player, anywhere, balance)`

---
## 15. Preservation

**Idea:** Delegatecall with mismatched storage layouts lets you overwrite slots.

**Notes:**
- `delegatecall` runs external code in caller's storage context.
- LibraryContract has `storedTime` in slot 0; Preservation has `timeZone1Library` in slot 0.
- When LibraryContract writes to its slot 0 via delegatecall, it overwrites Preservation's slot 0.
- Attack:
    - 1 - Call `setFirstTime(maliciousLibraryAddress)` to overwrite slot 0.
    - 2 - Call `setFirstTime(yourAddress)` - now delegates to our contract which writes to slot 2 (owner).
- Storage layouts must match exactly between caller and delegatecall target.
- Type casting: `address` → `uint160` → `uint256` to pass address as uint256 parameter.

---
## 16. Recovery

**Idea:** Contract addresses are deterministic and can be recovered.

**Notes:**
- `new Contract()` deploys at: `keccak256(rlp([deployer, nonce]))`.
- Recovery deployed first SimpleToken with nonce = 1.
- Compute lost address: `cast compute-address --nonce 1 RECOVERY_ADDRESS`.
- Lost contract has `destroy(address payable _to)` function → `selfdestruct(yourAddress)` drains ETH.
- Contract creation addresses are predictable
