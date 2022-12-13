// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IBounce {

    struct Order {
        address fromToken;
        address toToken;
        address toAddress;
        address BounceReceiver;
        uint256 fromTokenAmount;
        uint256 minAmtToToken;
        uint256 relayerFee;
        uint256 slippage;
        uint32 toDomainID_Connext;
    }

    function BounceFrom(Order memory _order, string memory _payload) external payable returns(bytes32);

    function BounceTo(
        address toAddress,
        address toToken,
        uint256 minToTokenAmount,
        bytes calldata payload    
    ) external returns (uint256);
}
