// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

interface INotifyExternal {
    function notifyExternal() external;
}

interface INotifyPublic {
    function notifyPublic() external;
}

/// @notice Verify that public and external functions cannot be accessed
///     during initialisation code execution
///     Answer: External and public functions cannot be accessed during
///     initialisation from other contract and from the constructor
///     making external calls. Public functions can be accessed in
///     the constructor if they are called internally (without `this`)
contract Q009ExternalAndPublicFunctionsNotAvailableAtInitialisationTest
    is Test, INotifyExternal, INotifyPublic {
    function testExternalCallToExternalFunctionInConstructorReverts(uint64 nonce) public {
        vm.expectRevert();

        new External();
    }

    function testExternalCallToExternalFunctionDuringInitialisationFromOtherContractReverts(uint64 nonce) public {
        vm.expectRevert();

        new ExternalNotify();
    }

    function testExternalCallToPublicFunctionInConstructorReverts(uint64 nonce) public {
        vm.expectRevert();

        new Public();
    }

    function testInternalCallToPublicFunctionInConstructorDoesNotRevert(uint64 nonce) public {
        new PublicInternalCall();
    }

    function testExternalCallToPublicFunctionDuringInitialisationFromOtherContractReverts(uint64 nonce) public {
        vm.expectRevert();

        new PublicNotify();
    }

    function notifyExternal() external {
        ExternalNotify(msg.sender).getValueExternal();
    }

    function notifyPublic() external {
        PublicNotify(msg.sender).getValuePublic();
    }
}

contract External {
    constructor() {
        this.getValueExternal();
    }

    function getValueExternal() external pure returns (uint256) {
        return 42;
    }
}

contract ExternalNotify {
    constructor() {
        INotifyExternal(msg.sender).notifyExternal();
    }

    function getValueExternal() external pure returns (uint256) {
        return 42;
    }
}

contract Public {
    constructor() {
        this.getValuePublic();
    }

    function getValuePublic() public pure returns (uint256) {
        return 42;
    }
}

contract PublicInternalCall {
    constructor() {
        getValuePublic();
    }

    function getValuePublic() public pure returns (uint256) {
        return 42;
    }
}

contract PublicNotify {
    constructor() {
        INotifyPublic(msg.sender).notifyPublic();
    }

    function getValuePublic() public pure returns (uint256) {
        return 42;
    }
}
