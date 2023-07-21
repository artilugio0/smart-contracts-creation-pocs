#!/bin/bash
# @notice Are the addresses of smart contracts deployed by EOAs computed in
#   the same way as smart contracts created with `create`?
#   Answer: yes, they are computed using keccak(rlp([sender,nonce]))[12:]

# anvil test account 0
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
ADDRESS="$(cast wallet address $PRIVATE_KEY)"

# start test blockchain
anvil >/dev/null 2>&1 &
sleep 3

# pre-compute the address using keccak(rlp([sender,nonce]))[12:]
# nonce is 0, so it will be encoded as an empty value
RLP=$(cast to-rlp '["'$ADDRESS'","0x"]')
COMPUTED_ADDRESS="0x$(cast keccak $RLP | tail -c +27)"

# deploy contract
BYTECODE="$(solc --bin src/SaveAddress.sol 2>/dev/null | tail -n1)"
cast send --private-key "$PRIVATE_KEY" --create $BYTECODE >/dev/null
sleep 1

# validate that there is code in the computed address
CODE_AT_ADDRESS=$(cast code $COMPUTED_ADDRESS)
if [ "$CODE_AT_ADDRESS" != '0x' ]
then
    echo 'PASS: contract address computed with `keccak(rlp([sender,nonce]))[12:]` has code'
else
    echo 'FAIL: contract address computed with `keccak(rlp([sender,nonce]))[12:]` does not have code'
fi

sleep 1
kill %1
