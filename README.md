# PoCs to understand the inner mechanics of smart contracts creation on chain

The purpose of this repository is to answer some questions I had while learning about smart contracts creation mechanics.

These are the questions I answered:

1. Does the initialisation code know the address of it's contract? (what's the value of `address(this)`?) - [Answer](./test/Q001ThisAddressDuringInitialisation.t.sol)
2. How can the address of a smart contract be pre-computed in solidity when using `create` and `create2`? - [Answer](./test/Q002SmartContractAddressComputation.t.sol)
3. When using `create`, is the nonce increased and then the address computed or is it computed with the current nonce? - [Answer](./test/Q003NonceIncreaseOnContractCreation.t.sol)
4. Does initialisation code have access to `address(this).balance`? - [Answer](./test/Q004InitialisationCodeCanAccessContractBalance.t.sol)
5. Verify that sending a transaction without `to` field is not the same as sending a transaction to the zero address (0x0000...) - [Answer](./test-scripts/Q005TransactionWithoutToVsToZeroAddress.sh)
6. How are initial values and immutable variables set in the initialisation code? - [Answer](./src/ImmutableVars.sol)
7. What is the output of the compilation of solc by default? (is it the creation code or the runtime code?)
    - Answer: the desired output can be specified using the flags `--bin` for creation or `--bin-runtime` for runtime
8. Are the addresses of smart contracts deployed by EOAs computed in the same way as smart contracts created with `create`? - [Answer](./test-scripts/Q008AddressOfContractsDeployedByEOA.sh)
9. Verify that public and external functions cannot be accessed during initialisation code execution - [Answer](./test/Q009ExternalAndPublicFunctionsNotAvailableAtInitialisation.t.sol)
10. Can the initialisation code sent by an EOA return an empty list of bytes? - [Answer](./test-scripts/Q010InitialisationCodeReturnsEmptyList.sh)
