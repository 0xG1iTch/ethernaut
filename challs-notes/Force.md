we can increase the balance of a contract even if it doesn't have a ppayable fallback or recieve function.
we can create our own contract that recieve eth, call selfdistruct with the target contract and te funds will go to the target.

a dangerous piece of code: `require(address(this).balance == 0, "Balance should be zero");`
if the attacker send funds to the contract he will stop this part of the cod from working and the contract will be kinda dead
 not only this but any logic that rely on a specific state of a contract balance is  unsade and can be manipulated.

 conclusion:
 Never rely on `address(this).balance` being predictable