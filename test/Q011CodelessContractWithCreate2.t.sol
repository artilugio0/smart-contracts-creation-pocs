// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CodelessContractFactory.sol";

/// @notice Can the initialisation code sent by a contract return
///     an empty list of bytes using `create2`?
///     Answer: yes
contract Q011CodelessContractWithCreate2Test is Test {
    function testCodelessContractCanBeDeployedWithCreate2() public {
        CodelessContractFactory factory = new CodelessContractFactory();
        address contractAddr = factory.deploy();

        // validate that the deploy worked
        bytes32 slot0 = vm.load(contractAddr, 0);
        assertEq(slot0, bytes32(uint256(42)));

        assertEq(contractAddr.code.length, 0);
    }
}
