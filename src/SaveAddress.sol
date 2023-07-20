pragma solidity 0.8.19;

contract SaveAddress {
    address public savedAddress;

    constructor() {
        savedAddress = address(this);
    }
}
