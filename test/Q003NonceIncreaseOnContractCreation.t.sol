// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SaveAddress.sol";
import "../src/computeAddress.sol" as computeAddress;

/// @notice When using `create`, is the nonce increased and then the address
///     computed or is it computed with the current nonce?
///     Answer: the current nonce is used and then incremented.
contract Q003NonceIncreaseOnContractCreationTest is Test {
    function testCurrentNonceIsUsedAndThenIncreased() public {
        uint64 nonce = 1337;
        vm.setNonce(address(this), nonce);

        SaveAddress c = new SaveAddress();

        address expected = address(c);
        address got = computeAddress.computeCreate(address(this), nonce);
        assertEq(got, expected);

        uint64 newNonce = vm.getNonce(address(this));
        assertEq(newNonce, nonce+1);
    }
}
