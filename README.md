Degen Gaming has selected the Avalanche blockchain, a leading blockchain platform for web3 gaming projects, to create a fast and low-fee token.

### DegenGamingToken

Inherits from the OpenZeppelin `ERC20` standard, providing core token functionality like `minting`, `transfer`, and balance management. Named "DegenGamingToken" with symbol "DGT".

### Store Items

Introduces a concept of store items with attributes like `ID`, `owner`, `name`, and `price`.
Stores these items in a mapping storeItems with the `ID` as the key.

### Owner Functions

`mint`: Allows the owner (set in the constructor) to mint new DGT tokens.
`addToStore`: Adds new items to the store with specified name and price.

### User Functions

`burn`: Allows users to burn their own DGT tokens.
`redeem`: Allows users to redeem store items by paying the price in DGT. This function has some interesting aspects:

- Users need to approve spending the required amount of DGT to the contract first.
- The contract then uses transferFrom to transfer the DGT from the user to the item owner.
  Finally, the item ownership is transferred to the user.
