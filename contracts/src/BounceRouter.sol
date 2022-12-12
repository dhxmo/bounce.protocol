// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IConnext} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IConnext.sol";

// TODO: add error if there's not enough liquidity to teleport over
// TODO: Zap into a vault that requires splits etc.


import "./interfaces/IBounce.sol";

contract BounceRouter is Ownable, IBounce {
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

        //require(_token.allowance(msg.sender, address(this)) >= amount, 
        //            "User must approve amount");
        
        _token.transferFrom(user, address(this), amount);
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
            _token.approve(spender, type(uint256).max);
        }
    }

    /*
     * Functions to bounce a token over to Receiver bounce contract 
     */

    // @dev user has to approve tokens
    function BounceFrom(Order memory _order) external override payable returns(bytes32)
        {
            // 1. add liquidity to bounce contract
            _addLiquidity(msg.sender, _order.fromToken, _order.fromTokenAmount); 

            uint256 fromTokenBalance = IERC20(_order.fromToken).balanceOf(address(this));
            // contract must have liquidity
            require(fromTokenBalance >= _order.fromTokenAmount, "You do not have enough funds for this bounce");
            

            // 2. approve token for connext bridge
            _tokenApproval(_order.fromToken, address(connext), _order.fromTokenAmount);

            // 3. connext bridge
            
            bytes memory _function = "";
            //bytes memory _toAddress = "";
            bytes memory payload = "";

            // TODO:: to be passed in dynamically according to protocol later
            _function = abi.encodeWithSignature("deposit(uint256)", _order.minAmtToToken);

            payload = abi.encode(_function, _order.toAddress);

            // relayer fee 0 for testnet
            bytes32 x = connext.xcall{value: 0}(
                _order.toDomainID_Connext,       // Domain ID of the destination chain
                _order.BounceReceiver,          // address of the target contract
                _order.fromToken,               // address of the token contract
                payable(msg.sender),            // address that can revert or forceLocal on destination
                _order.fromTokenAmount,         // amount of tokens to transfer
                _order.slippage,                // the maximum amount of slippage the user will accept in BPS
                payload                         // the encoded calldata to send
            );

            return x;
    }

    /*
     * Functions receiver bounce calls to send funds to wallet
     */

    // BounceReceiver will call this function
    function BounceTo( 
        address toAddress,
        address toToken,
        uint256 minToTokenAmount,
        bytes calldata payload
    )
        external
        override
        returns(uint256)
    {
        return _bounceTo(toAddress, toToken, minToTokenAmount, payload);
    }

    function _bounceTo(
        address toAddress,
        address toToken,
        uint256 minToTokenAmount,
        bytes calldata payload
    ) private returns(uint256) {
        require(approvedAddresses[toAddress], "This endpoint hasn't been approved by the admin.");

        // approve token that needs to be sent to the vualt
        _tokenApproval(toToken, toAddress, minToTokenAmount);

        // vault address -- call deposit specific to the vault being considered
        (bool success, ) = toAddress.call(payload);
        require(success, "Deposit unsuccessful");

        return minToTokenAmount;
    }

}
