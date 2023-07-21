pragma solidity 0.8.19;

import "./computeAddress.sol" as computeAddress;

contract CodelessContractFactory {
    function deploy() external returns (address contractAddress) {
        bytes memory initCode = abi.encodePacked(bytes5(0x602a600055));
        bytes32 salt;

        assembly {
            // add(initCode, 0x20) -> the first word is for the bytes length
            // mload(initCode) -> read the first word where the length is stored
            contractAddress := create2(0, add(initCode, 0x20), mload(initCode), salt)
        }
    }
}
