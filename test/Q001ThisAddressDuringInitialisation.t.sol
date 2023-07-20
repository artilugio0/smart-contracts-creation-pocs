// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SaveAddress.sol";

/// @notice Does the initialisation code know the address of it's contract?
///     Answer: yes.
///     The tests show that the address is known at initialization time using
///     `create` and `create2`
contract Q001ThisAddressDuringInitialisationTest is Test {
    function testSmartContractAddressIsKnownAtInitialisationWithCreate() public {
        SaveAddress c = new SaveAddress();

        address expected = address(c);
        address got = c.savedAddress();

        assertEq(got, expected);
    }

    function testSmartContractAddressIsKnownAtInitialisationWithCreate2() public {
        bytes32 salt = 0x72616e646f6d2076616c756520746f20626520757365642061732073616c7421;
        SaveAddress c = new SaveAddress{salt: salt}();

        address expected = address(c);
        address got = c.savedAddress();

        assertEq(got, expected);
    }
}
