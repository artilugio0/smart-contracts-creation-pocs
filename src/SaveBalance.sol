pragma solidity 0.8.19;

interface IBalanceObserver {
    function notifyBalance(uint256 balance) external;
}

contract SaveBalance {
    uint256 public savedBalance;

    constructor() payable {
        uint256 balance = address(this).balance;
        savedBalance = balance;

        IBalanceObserver(msg.sender).notifyBalance(balance);
    }
}
