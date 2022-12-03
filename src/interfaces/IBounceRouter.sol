// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IBounceRouter {
    struct Bounce_Route {
        address fromToken;
        address toToken;
        address swapAddress;
        bytes swapData;
    }

    struct Bounce_Order {
        // user executing the order
        address user;
        // source chain ID
        uint256 fromChainID;
        // connext specific source domain ID
        uint32 fromDomainId;
        // address of the source token
        address fromToken;
        // amount of surce token
        uint256 fromTokenAmount;
        // destination chain ID
        uint256 toChainID;
        // connext specific dest domain ID
        uint32 toDomainId;
        // address of destination token
        address toToken;
        // slippage
        uint256 minToTokenAmount;
    }

    struct Bounce_Bridge {
        uint256 srcDomainId;
        uint256 dstDomainId;
        address dstAddress;
    }

    function Bounce(
        Bounce_Order memory order,
        Bounce_Route[] calldata srcRoute,
        Bounce_Route[] calldata dstRoute,
        Bounce_Bridge calldata bridgeOptions
    ) external payable;
}
