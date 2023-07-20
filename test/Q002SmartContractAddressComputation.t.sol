// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SaveAddress.sol";
import "../src/computeAddress.sol" as computeAddress;

/// @notice How can the address of a smart contract be pre-computed in solidity
///     when using `create` and `create2`?
///     Answer: implementations can be found in `computeAddress.sol`
contract Q002SmartContractAddressComputationTest is Test {
    function testCreateAddressComputation(uint64 nonce) public {
        // set a valid nonce
        uint64 currentNonce = vm.getNonce(address(this));
        vm.assume(nonce < type(uint64).max && nonce > currentNonce);
        vm.setNonce(address(this), nonce);

        SaveAddress c = new SaveAddress();

        address expected = address(c);
        address got = computeAddress.computeCreate(address(this), nonce);

        assertEq(got, expected);
    }

    function testCreateAddressComputationWithZeroNonce() public {
        uint64 nonce = 0;

        address expected = 0x7D8CB8F412B3ee9AC79558791333F41d2b1ccDAC;
        address got = computeAddress.computeCreate(address(this), nonce);

        assertEq(got, expected);
    }

    function testCreate2AddressComputation(bytes32 salt) public {
        SaveAddress c = new SaveAddress{salt: salt}();

        address expected = address(c);

        address got = computeAddress.computeCreate2(
            address(this),
            type(SaveAddress).creationCode,
            salt
        );

        assertEq(got, expected);
    }
}
