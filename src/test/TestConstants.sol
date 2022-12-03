// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestConstants {
    address deployer = 0x3399FFB4ff1010b92357a22D329F724f45590fa5;
    address user1 = 0xC47E6da611DC4e8476445e0E2B56Baa97A4b12B9;
    uint256 userBalance = 20e18;
/*
 * Goerli
 */
    uint256 chainID_goerli = 5;
    uint32 domainID_goerli = 1735353714;
    address constant connext_goerli = 0xb35937ce4fFB5f72E90eAD83c10D33097a4F18D2;

    address constant weth_goerli = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    IERC20 wethGoerli = IERC20(weth_goerli);

/*
 * Mumbai
 */
    uint256 chainID_mumbai = 80001;
    uint32 domainID_mumbai = 9991;
    address constant connext_mumbai = 0xa2F2ed226d4569C8eC09c175DDEeF4d41Bab4627;

    address constant weth_mumbai = 0xFD2AB41e083c75085807c4A65C0A14FDD93d55A9;
        
}
