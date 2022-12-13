// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Constants is Ownable {
    // address => opcode
    mapping(address => bytes) private ProtocolFunctions;
    address[] private Protocols;
    string[] private ProtocolNames;

    mapping(address => bytes) private LPFunctions;
    address[] private LPs;
    string[] private LPNames;

    mapping(address => bytes) private VaultFunctions;
    address[] private Vaults;
    string[] private VaultNames;

    // here we add yearn vaults, beefy vaults, lido stake, aave deposit, multiple other functions across all top 10 TVL holding protocols in 5 chains
    // for now just testnets will do fine
    function addProtocolFunctions(
        string memory _protocolName,
        address _contractAddress,
        bytes memory _calldata
    ) external onlyOwner {
        ProtocolFunctions[_contractAddress] = _calldata;
        Protocols.push(_contractAddress);
        ProtocolNames.push(_protocolName);
    }

    function addLPFunctions(string memory _LPName,address _contractAddress, bytes memory _calldata)
        external
        onlyOwner
    {
        LPFunctions[_contractAddress] = _calldata;
        LPs.push(_contractAddress);
        LPNames.push(_LPName);
    }

    function addVaultFunctions(string memory _LPName, address _contractAddress, bytes memory _calldata)
        external
        onlyOwner
    {
        VaultFunctions[_contractAddress] = _calldata;
        Vaults.push(_contractAddress);
        VaultNames.push(_LPName);
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

    function getProtocolNames() external view returns(string[] memory) {
        return ProtocolNames;
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

        function getLPNames() external view returns(string[] memory) {
        return LPNames;
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

        function getVaultNames() external view returns(string[] memory) {
        return VaultNames;
    }
}

// nav in frontend will populate by reading this mapping and sending the appropriate calldata to Bounce

// the frontend will read these mappings as well to know which contract to hit with what calldata
// nav in frontend will populate by reading this mapping and sending the appropriate calldata to Bounce

// the frontend will read these mappings as well to know which contract to hit with what calldata
