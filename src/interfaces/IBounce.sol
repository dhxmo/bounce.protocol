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

    function BounceFrom(Order memory _order) external payable returns(bytes32);

    function BounceTo(
        address toAddress,
        address toToken,
        uint256 minToTokenAmount,
        bytes calldata payload    
    ) external returns (uint256);
}

// ["0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6", "0x1E5341E4b7ed5D0680d9066aac0396F0b1bD1E69", "0x75A8B79dB3E6A135af4473818a739eB3dF3dED43", "0x75A8B79dB3E6A135af4473818a739eB3dF3dED43", 100, 90, 0, 20, 80001]
