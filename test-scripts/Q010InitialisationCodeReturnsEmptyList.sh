#!/bin/bash
# @notice Can the initialisation code sent by an EOA return an empty list of bytes?
#   Answer: yes! It seems that it can even execute arbitrary code. The PoC below
#   stores the value 42 at storage slot 0 for the contract account, and the
#   contract account does not have code

# anvil test account 0
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
ADDRESS="$(cast wallet address $PRIVATE_KEY)"

# start test blockchain
anvil >/dev/null 2>&1 &
sleep 3

CURRENT_NONCE=$(cast nonce $ADDRESS)
CONTRACT_ADDRESS=$(cast compute-address --nonce $CURRENT_NONCE $ADDRESS | sed 's/.*0x/0x/')
BYTECODE="602a600055" # stores at slot 0 the value 42

# deploy codeless contract
cast send --private-key "$PRIVATE_KEY" --create $BYTECODE >/dev/null
sleep 1

# validate that there is no code in the computed address
CODE_AT_ADDRESS=$(cast code $CONTRACT_ADDRESS)
if [ "$CODE_AT_ADDRESS" == '0x' ]
then
    echo 'PASS: contract has no code'
else
    echo 'FAIL: contract has code'
fi

# validate that there is data at storage slot 0
SLOT0_VALUE=$(cast storage $CONTRACT_ADDRESS 0 | cast to-dec)
if [ "$SLOT0_VALUE" == '42' ]
then
    echo 'PASS: contract account has slot 0 with value 42'
else
    echo "FAIL: contract account slot 0 was not set to expected value. Got: $SLOT0_VALUE"
fi

sleep 1
kill %1
