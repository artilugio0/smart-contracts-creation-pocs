// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @notice Computes the address of a smart contract deployed using `create`
/// @param sender The address executing the `create` operation
/// @param nonce The current nonce of the sender account
/// @return address of the smart contract
function computeCreate(address sender, uint64 nonce) pure returns (address) {
    bytes memory senderAddressRlp = abi.encodePacked(uint8(0x80 + 20), sender); 

    bytes memory nonceRlp;
    if (nonce > 0 && nonce <= 0x7f) {
        nonceRlp = abi.encodePacked(uint8(nonce));
    } else {
        bytes memory trimmedNonce = _trimLeftZeros(abi.encodePacked(nonce));
        nonceRlp = abi.encodePacked(uint8(0x80 + trimmedNonce.length), trimmedNonce); 
    }

    bytes memory rlp = abi.encodePacked(
        uint8(0xc0 + senderAddressRlp.length + nonceRlp.length),
        senderAddressRlp,
        nonceRlp
    );

    return address(bytes20(keccak256(rlp) << (12*8)));
}

/// @notice Computes the address of a smart contract deployed using `create2`
/// @param sender The address executing the `create2` operation
/// @param initCode Initialization code of the smart contract
/// @param salt value to be used as salt
/// @return address of the smart contract
function computeCreate2(
    address sender,
    bytes memory initCode,
    bytes32 salt
) pure returns (address) {

    return address(bytes20(
        keccak256(
            abi.encodePacked(
                bytes1(0xff),
                sender,
                salt,
                keccak256(initCode)
            )
        ) << (12 * 8)
    ));
}

function _trimLeftZeros(bytes memory input) pure returns (bytes memory) {
    uint256 length = input.length;
    uint256 zerosCount = 0;
    while (zerosCount < length && input[zerosCount] == 0x00) {
        ++zerosCount;
    }

    uint256 resultLength = length - zerosCount;
    bytes memory result = new bytes(resultLength);
    for (uint256 i = 0; i < resultLength; ++i) {
        result[i] = input[zerosCount + i];
    }

    return result;
}
