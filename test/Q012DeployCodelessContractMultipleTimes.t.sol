// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CodelessContractFactory.sol";

/// @notice Can initialisation code sent by a contract that returns
///     and empty list of bytes be executed multiple times?
///     Answer: no, the second time `create2` will fail
contract Q012DeployCodelessContractMultipleTimes is Test {
    function testCodelessContractCanBeDeployedASingleTime() public {
        CodelessContractFactory factory = new CodelessContractFactory();
        address contractAddr = factory.deploy();

        // validate that the first deploy worked
        bytes32 slot0 = vm.load(contractAddr, 0);
        assertEq(slot0, bytes32(uint256(42)));

        // validate that the second deploy failed
        // (create2 returns 0 on error)
        address contractAddr2 = factory.deploy();
        assertEq(contractAddr2, address(0));
    }
}
