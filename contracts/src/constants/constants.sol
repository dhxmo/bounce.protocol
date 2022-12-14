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

    // domainID => approved token address
    mapping(uint32 => address[]) private approvedTokens;
    mapping(uint32 => string[]) private approvedTokenSymbols;

    function addProtocolFunctions(
        string memory _protocolName,
        address _contractAddress,
        bytes memory _calldata
    ) external onlyOwner {
        ProtocolFunctions[_contractAddress] = _calldata;
        Protocols.push(_contractAddress);
        ProtocolNames.push(_protocolName);
    }

    function addLPFunctions(
        string memory _LPName,
        address _contractAddress,
        bytes memory _calldata
    ) external onlyOwner {
        LPFunctions[_contractAddress] = _calldata;
        LPs.push(_contractAddress);
        LPNames.push(_LPName);
    }

    function addVaultFunctions(
        string memory _LPName,
        address _contractAddress,
        bytes memory _calldata
    ) external onlyOwner {
        VaultFunctions[_contractAddress] = _calldata;
        Vaults.push(_contractAddress);
        VaultNames.push(_LPName);
    }

    function addApprovedToken(uint32 _domainID, string memory _tokenSymbol, address _tokenAddress)
        external
        onlyOwner
    {
        approvedTokens[_domainID].push(_tokenAddress);
        approvedTokenSymbols[_domainID].push(_tokenSymbol);
    }

    /*
     * Get Functions
     */

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

    function getProtocolNames() external view returns (string[] memory) {
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

    function getLPNames() external view returns (string[] memory) {
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

    function getVaultNames() external view returns (string[] memory) {
        return VaultNames;
    }

    function getApprovedTokens(uint32 _domainID)
        external
        view
        returns (address[] memory)
    {
        return approvedTokens[_domainID];
    }

    function getApprovedTokenSymbols(uint32 _domainID)
        external
        view
        returns (string[] memory)
    {
        return approvedTokenSymbols[_domainID];
    }
}
