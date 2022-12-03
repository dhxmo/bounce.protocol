// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IConnext} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IConnext.sol";

import "./interfaces/IBounceRouter.sol";

contract BounceRouter is Ownable, IBounceRouter {
    using SafeERC20 for IERC20;

    // The connext contract on the origin domain.
    IConnext public immutable connext;

    uint256 immutable chainID;

    mapping(address => bool) public approvedAddresses;

    // _connext Address of deployed connext contract on present chain
    // _chainID ID of the present chain
    constructor(IConnext _connext, uint256 _chainID) {
        connext = _connext;
        chainID = _chainID;
    }

    /*
     * Function to have an approved list of addresses to swap against
     */
    function addApprovedSwapAddress(address _address) public onlyOwner {
        approvedAddresses[_address] = true;
    }

    function removeApprovedSwapAddress(address _address) public onlyOwner {
        delete approvedAddresses[_address];
    }

    // add token to this contract
    function _addLiquidity(
        address user,
        address token,
        uint256 amount
    ) internal returns (uint256) {
        IERC20(token).safeTransferFrom(user, address(this), amount);
        return amount;
    }

    // approve token for spender, preempt for transfer out of this contract
    function _approveToken(
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

    function Bounce(
        Bounce_Order memory order,
        Bounce_Route[] calldata srcRoute,
        Bounce_Route[] calldata dstRoute,
        Bounce_Bridge calldata bridgeOptions
    ) external payable {
        // each order has to be user specific
        require(msg.sender == order.user);

        _bounce(
            order,
            srcRoute,
            dstRoute,
            bridgeOptions
        );
    }

    function _bounce(
        Bounce_Order memory order,
        Bounce_Route[] calldata srcRoute,
        Bounce_Route[] calldata dstRoute,
        Bounce_Bridge calldata bridgeOptions
    ) private {
        // check we're in the right chain
        require(chainID == order.fromChainID);

        // get tokens that need to be bounnced over into this contract
        _addLiquidity(order.user, order.fromToken, order.fromTokenAmount);

        uint256 fromTokenBalance = IERC20(order.fromToken).balanceOf(address(this));
        // contract must have liquidity
        require(fromTokenBalance >= order.fromTokenAmount, "You do not have enough funds for this bounce");


    }
}
