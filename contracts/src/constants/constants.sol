// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Constants is Ownable {
    // address => opcode
    mapping(address => bytes) private ProtocolFunctions;
    address[] private Protocols;

    mapping(address => bytes) private LPFunctions;
    address[] private LPs;

    mapping(address => bytes) private VaultFunctions;
    address[] private Vaults;

    // here we add yearn vaults, beefy vaults, lido stake, aave deposit, multiple other functions across all top 10 TVL holding protocols in 5 chains
    // for now just testnets will do fine
    function addProtocolFunctions(
        address _contractAddress,
        bytes memory _calldata
    ) external onlyOwner {
        ProtocolFunctions[_contractAddress] = _calldata;
        Protocols.push(_contractAddress);
    }

    function addLPFunctions(address _contractAddress, bytes memory _calldata)
        external
        onlyOwner
    {
        LPFunctions[_contractAddress] = _calldata;
        LPs.push(_contractAddress);
    }

    function addVaultFunctions(address _contractAddress, bytes memory _calldata)
        external
        onlyOwner
    {
        VaultFunctions[_contractAddress] = _calldata;
        Vaults.push(_contractAddress);
    }

    function getAllProtocols() external view returns (address[] memory) {
        return Protocols;
    }

    function getProtocolCalldata(address _contractAddress)
        external
        view
        returns (bytes memory)
    {
        return ProtocolFunctions[_contractAddress];
    }

    function getAllLPs() external view returns (address[] memory) {
        return LPs;
    }

    function getLPCalldata(address _contractAddress)
        external
        view
        returns (bytes memory)
    {
        return LPFunctions[_contractAddress];
    }

    function getAllVaults() external view returns (address[] memory) {
        return Vaults;
    }

    function getVaultCalldata(address _contractAddress)
        external
        view
        returns (bytes memory)
    {
        return VaultFunctions[_contractAddress];
    }
}

// nav in frontend will populate by reading this mapping and sending the appropriate calldata to Bounce

// the frontend will read these mappings as well to know which contract to hit with what calldata
