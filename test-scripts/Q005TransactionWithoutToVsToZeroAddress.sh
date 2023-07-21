#!/bin/bash
# @notice Verify that sending a transaction without `to` field is not the same
#   as sending a transaction to the zero address (0x0000...).
#   Answer: sending a transaction without specifying `to` creates a smart contract.
#   sending a transaction with `to` field set to the zero address does not create
#   a smart contract.

# anvil test account 0
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
ADDRESS="$(cast wallet address $PRIVATE_KEY)"

# start test blockchain
anvil >/dev/null 2>&1 &
sleep 3

# get bytecode to deploy
BYTECODE="$(solc --bin src/SaveAddress.sol 2>/dev/null | tail -n1)"

# deploy contract by sending a transaction without `to` param
CURRENT_NONCE=$(cast nonce $ADDRESS)
CONTRACT_ADDRESS=$(cast compute-address --nonce $CURRENT_NONCE $ADDRESS | sed 's/.*0x/0x/')

cast rpc eth_sendTransaction '{
    "from": "'$ADDRESS'",
    "data": "0x'$BYTECODE'"
}' >/dev/null

CODE_AT_ADDRESS_1=$(cast code $CONTRACT_ADDRESS)

if [ "$CODE_AT_ADDRESS_1" != '0x' ]
then
    echo 'PASS: contract is only created if `to` is not set'
else
    echo 'FAIL: contract was not created with `to` not set'
fi


# try to deploy contract by sending a transaction with `to` param set to zero address
NEW_NONCE=$(cast nonce $ADDRESS)
NEW_CONTRACT_ADDRESS=$(cast compute-address --nonce $NEW_NONCE $ADDRESS | sed 's/.*0x/0x/')

cast rpc eth_sendTransaction '{
    "from": "'$ADDRESS'",
    "data": "0x'$BYTECODE'",
    "to": "0x0000000000000000000000000000000000000000"
}' >/dev/null

CODE_AT_ADDRESS_2=$(cast code $NEW_CONTRACT_ADDRESS)

if [ "$CODE_AT_ADDRESS_2" == '0x' ]
then
    echo 'PASS: contract is not created if `to` is set to the zero address'
else
    echo 'FAIL: contract was created with `to` set to the zero address'
fi

sleep 1
kill %1
