// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Constants is Ownable {
    // address => opcode
    mapping(address => bytes) ProtocolFunctions;
    mapping(address => bytes) LPFunctions;
    mapping(address => bytes) VaultFunctions;

    // here we add yearn vaults, beefy vaults, lido stake, aave deposit, multiple other functions across all top 10 TVL holding protocols in 5 chains
    // for now just testnets will do fine
    function addProtocolFunctions(
        address _contractAddress,
        bytes memory _calldata
    ) external onlyOwner {
        ProtocolFunctions[_contractAddress] = _calldata;
    }

    function addLPFunctions(address _contractAddress, bytes memory _calldata)
        external
        onlyOwner
    {
        LPFunctions[_contractAddress] = _calldata;
    }

    function addVaultFunctions(address _contractAddress, bytes memory _calldata)
        external
        onlyOwner
    {
        VaultFunctions[_contractAddress] = _calldata;
    }
}

// nav in frontend will populate by reading this mapping and sending the appropriate calldata to Bounce

// the frontend will read these mappings as well to know which contract to hit with what calldata
