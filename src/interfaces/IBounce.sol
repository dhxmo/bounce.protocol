// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IBounce {
    struct Bounce_Route {
        // address of source token
        address fromToken;
        // amount of source token
        uint256 fromTokenAmount;
        // address of destinaion token
        address toToken;
        // address of vault to swap into
        address toAddress;
        // payload to pass into vault
        bytes payload;
    }

    // Bounce_Order struct for the receiver
    struct Bounce_Order {
        // user executing the order
        address executor;
        // connext specific source domain ID
        uint32 fromDomainID;
        // connext specific dest domain ID
        uint32 toDomainID;
        // address of destination token
        address toToken;
        // slippage
        uint256 minToTokenAmount;
    }

    struct Bounce_Bridge {
        uint256 fromChainID;
        uint32 fromDomainID;
        address fromAddress;
        uint256 toChainID;
        uint32 toDomainID;
        address toAddress;
    }

    function BounceFrom(
        Bounce_Order calldata order,
        Bounce_Route calldata route,
        Bounce_Bridge calldata bridgeOptions,
        address BounceReceiver,
        uint256 relayerFee,
        uint256 slippage
    ) external payable;

    function BounceTo(
        Bounce_Order calldata order,
        Bounce_Route calldata route
    ) external returns (uint256);
}
