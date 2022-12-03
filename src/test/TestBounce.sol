// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "forge-std/Test.sol";

import "./TestConstants.sol";

import "../BounceRouter.sol";
import "../BounceReceiver.sol";
import "../mock/MockReceiverVault.sol";

contract TestBounce is Test, TestConstants {
    uint256 goerli_forkID;
    uint256 mumbai_forkID;

    BounceRouter bounce_goerli;

    BounceReceiver bounce_mumbai;
    BounceRouter bounceRouter_mumbai;
    MockReceiverVault mockReceiver_mumbai;

    function setUp() public {
        goerli_forkID = vm.createFork("goerli");
        mumbai_forkID = vm.createFork("mumbai");

        vm.startPrank(deployer);

        /*
         * goerli deployments
         */
        vm.selectFork(goerli_forkID);
        assertEq(vm.activeFork(), goerli_forkID);

        // create new BounceRouter contract instance on src chain
        bounce_goerli = new BounceRouter(connext_goerli, chainID_goerli, domainID_goerli);
        vm.makePersistent(address(bounce_goerli));

        /*
         * mumbai deployements
         */
        vm.selectFork(mumbai_forkID);
        assertEq(vm.activeFork(), mumbai_forkID);

        // create new BounceReceiver instance on dest chain
        bounce_mumbai = new BounceReceiver(connext_mumbai, chainID_mumbai, domainID_mumbai);
        vm.makePersistent(address(bounce_mumbai));

        // create new BounceRouter instance on dest chain
        bounceRouter_mumbai = new BounceRouter(connext_mumbai, chainID_mumbai, domainID_mumbai);
        vm.makePersistent(address(bounceRouter_mumbai));

        mockReceiver_mumbai = new MockReceiverVault();

        vm.stopPrank();
    }

    function test_BounceRouter() external {
        vm.selectFork(goerli_forkID);
        assertEq(vm.activeFork(), goerli_forkID);

        // add USDC to user aaccount
        deal(weth_goerli, user1, userBalance);
        vm.startPrank(user1);

        assertEq(wethGoerli.balanceOf(user1), userBalance);
    }
}
