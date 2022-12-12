// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "forge-std/Test.sol";

import "./TestConstants.sol";

import "../BounceRouter.sol";
import "../BounceReceiver.sol";
import "../interfaces/IBounce.sol";
import "../mock/MockReceiverVault.sol";

contract TestBounce is Test, TestConstants {
    uint256 goerli_forkID;
    uint256 mumbai_forkID;

    BounceRouter bounceRouter_goerli;

    BounceReceiver bounceReceiver_mumbai;
    BounceRouter bounceRouter_mumbai;
    MockReceiverVault mockReceiver_mumbai;

    uint256 amount2Send = 1200;
    uint256 minAmount2Send = 1000;


    function setUp() public {
        goerli_forkID = vm.createFork("goerli");
        mumbai_forkID = vm.createFork("mumbai");

        vm.startPrank(deployer);

        /*
         * mumbai deployements
         */
        vm.selectFork(mumbai_forkID);
        assertEq(vm.activeFork(), mumbai_forkID);

        // create new BounceReceiver instance on dest chain
        bounceReceiver_mumbai = new BounceReceiver(connext_mumbai, chainID_mumbai, domainID_mumbai);
        vm.makePersistent(address(bounceReceiver_mumbai));

        // create new BounceRouter instance on dest chain
        bounceRouter_mumbai = new BounceRouter(connext_mumbai, chainID_mumbai, domainID_mumbai);
        vm.makePersistent(address(bounceRouter_mumbai));

        // add vault where funds will go. in main, this would be Beefy finance etc
        mockReceiver_mumbai = new MockReceiverVault(); 
        vm.makePersistent(address(mockReceiver_mumbai));

        // approve vault address on router on dest chain
        bounceRouter_mumbai.addApprovedSwapAddress(address(mockReceiver_mumbai));

         /*
          *goerli deployments
          */
        vm.selectFork(goerli_forkID);
        assertEq(vm.activeFork(), goerli_forkID);

        // create new BounceRouter contract instance on src chain
        bounceRouter_goerli = new BounceRouter(connext_goerli, chainID_goerli, domainID_goerli);
        vm.makePersistent(address(bounceRouter_goerli));

        vm.stopPrank();
    }

     function test_1_BounceRouter() public {
         vm.selectFork(goerli_forkID);
         assertEq(vm.activeFork(), goerli_forkID);
 
         // add USDC to user aaccount
         deal(weth_goerli, user1, userBalance);
         vm.startPrank(user1);
 

         assertEq(wethGoerli.balanceOf(user1), userBalance);
 
         wethGoerli.approve(address(bounceRouter_goerli), 12e18);

         IBounce.Order memory _order = IBounce.Order(
            weth_goerli,
            tWeth_mumbai,
            address(mockReceiver_mumbai),
            address(bounceReceiver_mumbai),
            amount2Send,
            minAmount2Send,
            0,
            20,
            domainID_mumbai
         );
 
         bytes32 x = bounceRouter_goerli.BounceFrom(_order);
 
         emit log_named_bytes32("return bytes from xcall", x);
     }

     function test_2_BounceReceiver() public {
        vm.selectFork(mumbai_forkID);
        assertEq(vm.activeFork(), mumbai_forkID);

        vm.startPrank(deployer);
        bounceReceiver_mumbai.setBounceRouter(address(bounceRouter_mumbai));
        

        bytes memory _function = "";
        bytes memory _toAddress = "";
        bytes memory payload = "";

        // TODO:: to be passed in dynamically according to protocol later
        _function = abi.encodeWithSignature("deposit(uint256)", minAmount2Send);

        payload = abi.encode(_function, address(mockReceiver_mumbai));

        bounceReceiver_mumbai.xReceive(
            convert(1),
            minAmount2Send,
            tWeth_mumbai,
            user1,
            domainID_goerli,
            payload
        );
     }

    function convert(uint256 n) internal returns (bytes32) {
        return bytes32(n);
    }
}
