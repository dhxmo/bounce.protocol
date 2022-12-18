// chainID => receiver contract deployed on that chain
const BOUNCE_RECEIVER_ADDRESS = {
    "0x5": "", // goerli
    "0x1": "", // mock mainnet
    "0x13881": "", // mumbai
    "0x89": "", // mock polygon
    "0xA4B1": "", // mock arbitrum
    "0xA": "", // mock optimism
    "0x7a69": "", // local test
};

const BOUNCE_ADDRESS = "";
const BOUNCE_ABI = [];

const BOUNCE_CONSTANTS_ADDRESS = "0x08e1b6f3f49DECcD192318999A373a496E952dd0";
const BOUNCE_CONSTANTS_ABI = [
    {
        inputs: [
            {
                internalType: "uint32",
                name: "_domainID",
                type: "uint32",
            },
            {
                internalType: "string",
                name: "_tokenSymbol",
                type: "string",
            },
            {
                internalType: "address",
                name: "_tokenAddress",
                type: "address",
            },
        ],
        name: "addApprovedToken",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_LPName",
                type: "string",
            },
            {
                internalType: "address",
                name: "_contractAddress",
                type: "address",
            },
            {
                internalType: "bytes",
                name: "_calldata",
                type: "bytes",
            },
        ],
        name: "addLPFunctions",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_protocolName",
                type: "string",
            },
            {
                internalType: "address",
                name: "_contractAddress",
                type: "address",
            },
            {
                internalType: "bytes",
                name: "_calldata",
                type: "bytes",
            },
        ],
        name: "addProtocolFunctions",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_LPName",
                type: "string",
            },
            {
                internalType: "address",
                name: "_contractAddress",
                type: "address",
            },
            {
                internalType: "bytes",
                name: "_calldata",
                type: "bytes",
            },
        ],
        name: "addVaultFunctions",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "previousOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "OwnershipTransferred",
        type: "event",
    },
    {
        inputs: [],
        name: "renounceOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "transferOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "getAllLPs",
        outputs: [
            {
                internalType: "address[]",
                name: "",
                type: "address[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "getAllProtocols",
        outputs: [
            {
                internalType: "address[]",
                name: "",
                type: "address[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "getAllVaults",
        outputs: [
            {
                internalType: "address[]",
                name: "",
                type: "address[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint32",
                name: "_domainID",
                type: "uint32",
            },
        ],
        name: "getApprovedTokens",
        outputs: [
            {
                internalType: "address[]",
                name: "",
                type: "address[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint32",
                name: "_domainID",
                type: "uint32",
            },
        ],
        name: "getApprovedTokenSymbols",
        outputs: [
            {
                internalType: "string[]",
                name: "",
                type: "string[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_contractAddress",
                type: "address",
            },
        ],
        name: "getLPCalldata",
        outputs: [
            {
                internalType: "bytes",
                name: "",
                type: "bytes",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "getLPNames",
        outputs: [
            {
                internalType: "string[]",
                name: "",
                type: "string[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_contractAddress",
                type: "address",
            },
        ],
        name: "getProtocolCalldata",
        outputs: [
            {
                internalType: "bytes",
                name: "",
                type: "bytes",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "getProtocolNames",
        outputs: [
            {
                internalType: "string[]",
                name: "",
                type: "string[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_contractAddress",
                type: "address",
            },
        ],
        name: "getVaultCalldata",
        outputs: [
            {
                internalType: "bytes",
                name: "",
                type: "bytes",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "getVaultNames",
        outputs: [
            {
                internalType: "string[]",
                name: "",
                type: "string[]",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "owner",
        outputs: [
            {
                internalType: "address",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
];

export { BOUNCE_ADDRESS, BOUNCE_ABI, BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI, BOUNCE_RECEIVER_ADDRESS};
