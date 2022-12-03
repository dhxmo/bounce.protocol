// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IConnext} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IConnext.sol";

import "./interfaces/IBounce.sol";

contract BounceRouter is Ownable, IBounce {
    using SafeERC20 for IERC20;

    // The connext contract on the origin domain.
    IConnext public immutable connext;

    uint256 immutable chainID;
    uint32 immutable domainID;

    mapping(address => bool) public approvedAddresses;

    // _connext Address of deployed connext contract on present chain
    // _chainID ID of the present chain
    // _domainID ID of the present chain for connext
    constructor(address _connext, uint256 _chainID, uint32 _domainID) {
        connext = IConnext(_connext);
        chainID = _chainID;
        domainID = _domainID;
    }

    /*
     * Function to have an approved list of vaults
     */
    function addApprovedSwapAddress(address _address) public onlyOwner {
        approvedAddresses[_address] = true;
    }

    function removeApprovedSwapAddress(address _address) public onlyOwner {
        delete approvedAddresses[_address];
    }

    // add token to this contract
    // @return amount of tokens deposited to this contract
    function _addLiquidity(
        address user,
        address token,
        uint256 amount
    ) internal returns (uint256) {
        IERC20 _token = IERC20(token);

        require(_token.allowance(msg.sender, address(this)) >= amount, 
                    "User must approve amount");
        
        _token.safeTransferFrom(user, address(this), amount);
        return amount;
    }

    // approve token for spender, preempt for transfer out of this contract
    function _tokenApproval(
        address token,
        address spender,
        uint256 amount
    ) internal {
        IERC20 _token = IERC20(token);
        if (_token.allowance(address(this), spender) >= amount) return;
        else {
            _token.safeApprove(spender, type(uint256).max);
        }
    }

    /*
     * Functions to bounce a token over to Receiver bounce contract 
     */
    function BounceFrom(
        Bounce_Order calldata order,
        Bounce_Route calldata route,
        Bounce_Bridge calldata bridge,
        address BounceReceiver,
        uint256 relayerFee,
        uint256 slippage
    )   external 
        override 
        payable 
        {
        // each order has to be user specific
        require(msg.sender == order.executor);

       // TODO: use bridge options and add require checks

        // check we're in the right chain
        require(chainID == bridge.fromChainID);

        // 1. add liquidity to bounce contract

        _addLiquidity(order.executor, route.fromToken, route.fromTokenAmount); 
        uint256 fromTokenBalance = IERC20(route.fromToken).balanceOf(address(this));
        // contract must have liquidity
        require(fromTokenBalance >= route.fromTokenAmount, "You do not have enough funds for this bounce");

        // 2. approve token for connext bridge
        _tokenApproval(route.fromToken, address(connext), route.fromTokenAmount);

        // 3. connext bridge
        bytes memory payload = "";
        payload = abi.encode(order, route);

        connext.xcall{value: relayerFee}(
            order.toDomainID,       // Domain ID of the destination chain
            BounceReceiver,         // address of the target contract
            route.fromToken,        // address of the token contract
            payable(msg.sender),    // address that can revert or forceLocal on destination
            route.fromTokenAmount,  // amount of tokens to transfer
            slippage,               // the maximum amount of slippage the user will accept in BPS
            payload                 // the encoded calldata to send
        );
    }

/*
 *    function _bounceFrom(
 *        Bounce_Order calldata order,
 *        Bounce_Route calldata route,
 *        Bounce_Bridge calldata bridge,
 *        // Bounce receiver contract to further execute the vault deposit
 *        address BounceReceiver,
 *        uint256 relayerFee,
 *        uint256 slippage
 *    ) private {
 *
 *            }
 */

    /*
     * Functions receiver bounce calls to send funds to wallet
     */

    // BounceReceiver will call this function
    function BounceTo(Bounce_Order calldata order, Bounce_Route calldata route)
        external
        override
        returns(uint256)
    {
        return _bounceTo(order, route);
    }

    function _bounceTo(
        Bounce_Order calldata order, 
        Bounce_Route calldata route
    ) private returns(uint256) {
        require(approvedAddresses[route.toAddress], "This endpoint hasn't been approved by the admin.");

        // approve token that needs to be sent to the vualt
        _tokenApproval(route.toToken, route.toAddress, order.minToTokenAmount);

        // vault address -- call deposit specific to the vault being considered
        (bool success, ) = (route.toAddress).call(route.payload);
        require(success, "Deposit unsuccessful");

        return order.minToTokenAmount;
    }

}
