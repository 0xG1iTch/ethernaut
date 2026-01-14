Interaction with other contracts should be the very last step in any function.
updating state variable must be done first to prevent any kind of re-entrency to your contract

Transfer() and send() contracts are no more considered safe they are limited to 2300 gas to barely recieve eth and perform a simple evvent but they can't modify state variables or interact with other contract. But the Ethereum network can update how much gas each operation cost, and if this goas low it might makes those functions able to perform a re-entrency