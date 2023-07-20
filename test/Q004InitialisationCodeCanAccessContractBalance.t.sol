// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SaveBalance.sol";

/// @notice Does initialisation code have access to `address(this).balance`?
///     Answer: yes.
contract Q004NonceIncreaseOnContractCreationTest is Test {
    uint256 gotBalance;

    function testInitialisationCodeHasAccessToAddressBalance() public {
        uint256 expected = 1 ether;
        SaveBalance c = new SaveBalance{value: expected}();

        uint256 got = c.savedBalance();
        assertEq(got, expected);
    }

    function testInitialisationCodeHasAccessToAddressBalanceUsingCallback() public {
        uint256 expected = 1 ether;
        new SaveBalance{value: expected}();

        uint256 got = gotBalance;
        assertEq(got, expected);
    }

    /// @notice Receive balance value from SaveBalance contract.
    function notifyBalance(uint256 balance) external {
        gotBalance = balance;
    }
}
