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

    // user => token => amount
    mapping(address => mapping(address => uint256)) userFundsContractOwned;
    // user => token => vault => amount
    mapping(address => mapping(address => mapping(address => uint256))) userFundVaults;

    // _connext Address of deployed connext contract on present chain
    // _chainID ID of the present chain 
    // _domainID ID of the present chain for connext
    constructor(address _connext, uint256 _chainID, uint32 _domainID) {
        connext = IConnext(_connext);
        chainID = _chainID;
        domainID = _domainID;
    }

    function setBounceRouter(address _bounceRouterAddress) external onlyOwner {
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

    // mapping user => uint256
    // how much a user will withdraw when he comes back for his money

    // receive bounce order from source chain
    function xReceive(
        bytes32 _transferId, // unique ID for the transfer - generated on the origin chain
        uint256 _amount, // amount from the source (accounting for slippage)
        address _asset, // destination chain asset
        address _originSender, // original source sender
        uint32 _origin, // source domain ID
        bytes memory _payload // payload
    ) external returns (bytes memory) {
       
        // approve asset for bounce router to send to vault
        _tokenApproval(_asset, address(bounceRouter), _amount);

        (bytes memory _calldata, address toAddress) = abi.decode(_payload, (bytes, address));


        try IBounce(bounceRouter).BounceTo(toAddress, _asset, _amount, _calldata) returns (uint256 amtSent){
            // require the amount sent by the BounceTo function is gt.et the amount we sent over
            require(amtSent >= _amount);
            
            // funds that have been sent over for this user
            userFundsContractOwned[_originSender][_asset] = _amount;
            userFundVaults[_originSender][_asset][toAddress] += _amount;

        } catch {
          // if external call fails, send funds to wallet address of user on this chain
          IERC20(_asset).transfer(_originSender, _amount);
        }
    }

    // TODO: implement functionality to withdraw funds of the users when they want
}
