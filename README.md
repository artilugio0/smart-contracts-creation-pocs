# PoCs to understand the inner mechanics of smart contracts creation on chain

The purpose of this repository is to answer some questions I had while learning about smart contracts creation mechanics.

These are the questions I answered:

1. Does the initialisation code know the address of it's contract? (what's the value of `address(this)`?)
    - Answer: yes, `address(this)` returns the address assigned to the smart contract being created
    - [PoC](./test/Q001ThisAddressDuringInitialisation.t.sol)
2. How can the address of a smart contract be pre-computed in solidity when using `create` and `create2`?
    - Answer: yes, there are no builtin functions, but they can be implemented. In the case of create, the nonce has to be supplied externally since there is no way to access an account nonce from a smart contract at the moment
    - [PoC](./test/Q002SmartContractAddressComputation.t.sol)
3. When using `create`, is the nonce increased and then the address computed or is it computed with the current nonce?
    - Answer: the current nonce is used and then increased
    - [PoC](./test/Q003NonceIncreaseOnContractCreation.t.sol)
4. Does initialisation code have access to `address(this).balance`?
    - Answer: yes, it does
    - [PoC](./test/Q004InitialisationCodeCanAccessContractBalance.t.sol)
5. Verify that sending a transaction without `to` field is not the same as sending a transaction to the zero address (0x0000...)
    - Answer: sending a transaction without `to` is different than sending a transaction to the zero address
    - [PoC](./test-scripts/Q005TransactionWithoutToVsToZeroAddress.sh)
6. How are initial values and immutable variables set in the initialisation code?
    - Answer: the initialisation code will modify the runtime code before returning it to hardcode the value of immutable variables
    - [PoC](./src/ImmutableVars.sol)
7. What is the output of the compilation of solc by default? (is it the creation code or the runtime code?)
    - Answer: the desired output can be specified using the flags `--bin` for creation or `--bin-runtime` for runtime
8. Are the addresses of smart contracts deployed by EOAs computed in the same way as smart contracts created with `create`?
    - Answer: yes, they are computed in the same way as smart contracts created with `create`
    - [PoC](./test-scripts/Q008AddressOfContractsDeployedByEOA.sh)
9. Verify that public and external functions cannot be accessed during initialisation code execution
    - Answer: external and public functions cannot be called externally during initialisation in the constructor or by other smart contract
    - [PoC](./test/Q009ExternalAndPublicFunctionsNotAvailableAtInitialisation.t.sol)
10. Can the initialisation code sent by an EOA return an empty list of bytes?
    - Answer: yes, it can. If no value is returned, the smart contract will not have code saved to its account
    - [PoC](./test-scripts/Q010InitialisationCodeReturnsEmptyList.sh)
11. Can the initialisation code sent by a contract return an empty list of bytes using `create2`?
    - Answer: yes, it can
    - [PoC](./test/Q011CodelessContractWithCreate2.t.sol)
12. Can initialisation code sent by a contract that returns an empty list of bytes be executed multiple times using create2 with the same salt?
    - Answer: no, the execution will revert, even if the contract does not have code associated
    - [PoC](./test/Q012DeployCodelessContractMultipleTimes.t.sol)
