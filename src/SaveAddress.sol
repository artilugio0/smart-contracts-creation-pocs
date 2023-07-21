pragma solidity >= 0.8.19 < 0.9.0;

contract SaveAddress {
    address public savedAddress;

    constructor() {
        savedAddress = address(this);
    }
}
