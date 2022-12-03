// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IXReceiver} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IXReceiver.sol";
import {IConnext} from "@connext/nxtp-contracts/contracts/core/connext/interfaces/IConnext.sol";

import "./interfaces/IBounce.sol";

contract BounceReceiver is IXReceiver, Ownable {

    using SafeERC20 for IERC20;

    // The address of the Connext contract on the destination domain
    IConnext public connext;
    
    uint256 immutable chainID;
    uint32 immutable domainID;

    // address of deployed router on this chain
    IBounce public bounceRouter;
    
    // _connext Address of deployed connext contract on present chain
    // _chainID ID of the present chain
    constructor(IConnext _connext, uint256 _chainID, uint32 _domainID) {
        connext = _connext;
        chainID = _chainID;
        domainID = _domainID;
    }

    function setBounceRouter(address _bounceRouterAddress) onlyOwner external {
        bounceRouter = IBounce(_bounceRouterAddress);
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


    function xReceive(
        bytes32 _transferId,        // unique ID for the transfer - generated on the origin chain
        uint256 _amount,            // amount from the source (accounting for slippage)
        address _asset,             // destination chain asset
        address _originSender,      // original source sender
        uint32 _origin,             // source domain ID
        bytes memory _callData      // payload
      ) external returns (bytes memory) {

        IBounce.Bounce_Order memory bo;
        IBounce.Bounce_Route memory br;
        
        (bo, br) = abi.decode(
            _callData,
            (IBounce.Bounce_Order, IBounce.Bounce_Route)
        );

        // define the bounce order on destination
        IBounce.Bounce_Order memory to_Bounce_Order = IBounce.Bounce_Order(
            address(this),
            _origin,
            domainID,
            _asset,
            _amount
        );

        _tokenApproval(_asset, address(connext), _amount);

        // IBounceRouter(bounceRouter).BounceTo(); 

        /*
         *try {
         *  //someExternalCall();
         *  // BounceTo();
         *} catch { 
         *  // Make sure funds are delivered to logical owner on failing external calls
         *}
         */
      }
}


