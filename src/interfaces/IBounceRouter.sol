// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IBounceRouter {
    struct Bounce_Route {
        // address of source token 
        address fromToken;
        // address of destination token
        address toToken;
        // address of vault to swap into
        address toAddress;
        // payload to pass into vault
        bytes payload;
    }

    struct Bounce_Order {
        // user executing the order
        address user;
        // source chain ID
        uint256 fromChainID;
        // connext specific source domain ID
        uint32 fromDomainID;
        // address of the source token
        address fromToken;
        // amount of surce token
        uint256 fromTokenAmount;
        // destination chain ID
        uint256 toChainID;
        // connext specific dest domain ID
        uint32 toDomainID;
        // address of destination token
        address toToken;
        // slippage
        uint256 minToTokenAmount;
    }

    struct Bounce_Bridge {
        // source chain ID
        uint256 fromChainID;
        uint32 fromDomainID;
        uint256 toChainID;
        uint32 toDomainID;
        address toAddress;
    }

    function Bounce(
        Bounce_Order memory order,
        Bounce_Route[] calldata route,
        //Bounce_Bridge calldata bridgeOptions,
        address BounceReceiver,
        uint256 relayerFee,
        uint256 slippage
    ) external payable;
}
