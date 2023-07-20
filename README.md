# PoCs to understand the inner mechanics of smart contracts creation on chain

The purpose of this repository is to answer some questions I had while learning about smart contracts creation mechanics.

These are the questions I answered:

- Does the initialization code know the address of it's contract? (what's the value of `address(this)`?)
- Does initialization code have access to `address(this).balance`?
- Sending a transaction without `to` field is not the same as sending a transaction to the zero address (0x0000...)
- How are initial values and immutable variables set in the initialization code?
- What is the output of the compilation of solc by default? (is it the creation code or the runtime code?)
- Are the addresses of smart contracts deployed by EOAs computed in the same way as smart contracts created with `create`?
- Verify that public and external functions cannot be accessed during initialization code execution
- Can the initialisation code return empty list of bytes?
