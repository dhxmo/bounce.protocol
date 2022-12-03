// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MockReceiverVault {
    uint256 balance;

    function deposit(uint256 amount) external {
        //require(msg.value > 0, "Send some ETH");
        
        balance += amount;
    }
}
