import React, { useState, useEffect } from "react";
import { Radio } from "@material-tailwind/react";
import Web3Modal from "web3modal";
import { ethers } from "ethers";

import { DropdownWidget } from "./index";
import { validChains, bounceTo, LPAddresses, VaultAddresses, chainDomainID } from "../utils/index";
import { BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI } from "../config";

const BounceWidget = ({ constantsContract }) => {
    const [contract, setContract] = useState();

    const [inputValue, setInputValue] = useState(0);
    const [inputToken, setInputToken] = useState("");
    const [targetChain, setTargetChain] = useState("");
    const [slippage, setSlippage] = useState(0);
    const [bounceToType, setBounceToType] = useState("");
    const [contractTo, setContractTo] = useState("");
    const [outputToken, setOutputToken] = useState("");

    // contracts used in a protocol/lp/vault
    const [useAddress, setUseAddress] = useState([]);

    //
    const [protocolAddresses, setProtocolAddresses] = useState([]);

    // prevent infinite render
    useEffect(() => {
        async function getContract() {
            const web3Modal = new Web3Modal();
            const connection = await web3Modal.connect();

            const provider = new ethers.providers.Web3Provider(window.ethereum);

            let _contract = new ethers.Contract(BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI, provider);

            setContract(_contract);
        }
        getContract();
    }, [contract]);

    // helper function to populate all the protocols to be bounced into
    async function protocols() {
        const ProtocolAddresses = [];

        const addresses = await contract.getAllProtocols();
        const names = await contract.getProtocolNames();
        for (let i = 0; i < names.length; i++) {
            ProtocolAddresses.push({
                type: names[i],
                key: addresses[i],
            });
        }

        setUseAddress(ProtocolAddresses);
    }

    // helper function to populate all the LPs to be bounced into
    async function lps() {
        const ProtocolAddresses = [];

        const addresses = await contract.getAllLPs();
        const names = await contract.getLPNames();
        for (let i = 0; i < names.length; i++) {
            ProtocolAddresses.push({
                type: names[i],
                key: addresses[i],
            });
        }

        setUseAddress(ProtocolAddresses);
    }

    // helper function to populate all the vaultss to be bounced into
    async function vaults() {
        const ProtocolAddresses = [];

        const addresses = await contract.getAllVaults();
        const names = await contract.getVaultNames();
        for (let i = 0; i < names.length; i++) {
            ProtocolAddresses.push({
                type: names[i],
                key: addresses[i],
            });
        }

        setUseAddress(ProtocolAddresses);
    }

    async function inputTokens() {
        const InputTokens = [];

        const chainID = window.ethereum.chainId;
        const domain = chainDomainID.chainID;
        const addresses = await contract.getApprovedTokens(domain);
        const names = await contract.getApprovedTokenSymbols(domain);

        for (let i = 0; i < names.length; i++) {
            InputTokens.push({
                type: names[i],
                key: addresses[i],
            });
        }

        setInputToken(InputToken);
    }

    const handleInputChange = (e) => {
        // handle input chaage
        setInputValue(e.target.value);

        // fetch approved tokens in the present chain
        inputTokens();
    };

    const handleSlippageChange = (e) => {
        setSlippage(e.target.value);
    };

    const getInputToken = (data) => {
        setInputToken(data);
    };

    const getChainData = (data) => {
        setTargetChain(data.anchorKey);
    };

    const getBounceToData = (data) => {
        setBounceToType(data.anchorKey);
    };

    const getContractAddressData = (data) => {
        setContractTo(data.anchorKey);
    };

    const bounce = () => {
        {
            /*
             * when sending data crosschain
             *
             *  IBounce.Order memory _order = IBounce.Order(
             *
             *   weth_goerli,                       (inputToken)
             *   tWeth_mumbai,                      (outputToken)
             *   address(mockReceiver_mumbai),      (contractTo)
             *   address(bounceReceiver_mumbai),    (import - hardcode receiver address)
             *   amount2Send,                       (inputValue)
             *   minAmount2Send,                    (inputValue - slippage*inputValue)
             *   0,                                 (cointract function to computre relayer fee)
             *   20,                                (slippage)
             *   domainID_mumbai                    (destination domainID, from a mapping of destination hex to domainID of connext
             *                                              use object of hex to domainID for connext to obtain this from (targetChain)
             *                                                  )
             *);
             *
             * to be fetched from constants contract, getProtocol/LP/VaultCallData(address)
             *string memory _payloadString = "deposit(uint256)";
             */
        }

        // create an order tuple
        //
    };

    return (
        <div className="rounded-lg bg-orange-100 shadow-md p-10 grid grid-cols-1 grid-rows-3 place-items-center">
            <div className="flex">
                <input name="inputValue" type="number" value={inputValue} onChange={handleInputChange} className="mx-5" />

                {/*
  *1. get present chain from wallet
  2. find out avaialbel token addresses for present chain from constants contract
  */}
                <DropdownWidget menuItems={inputToken} sendData={getInputToken} />
            </div>

            <div className="grid grid-cols-1 grid-rows-3 justify-items-center items-start place-content-start">
                <div className="flex items-center">
                    <p className="mx-6">Destination chain</p>
                    <DropdownWidget menuItems={validChains} sendData={getChainData} />
                </div>

                <div className="flex items-center">
                    <p>slippage(%)</p>
                    <input name="slippage" type="number" value={slippage} onChange={handleSlippageChange} className="mx-5" />
                </div>

                <div className="grid grid-rows-1 grid-cols-3 gap-x-5 justify-items-center">
                    <Radio id="protocol" name="type" label="Protocol" onClick={protocols} />
                    <Radio id="lp" name="type" label="LP" onClick={lps} />
                    <Radio id="vault" name="type" label="Vault" onClick={vaults} />
                </div>

                {/*
                 * add input for slippage - add state and that bvecome the minAmountToSend
                 */}

                {/*
                 * which specific protocol/LP/vault. this will query constants contract
                 */}
                <div className="my-6 flex">
                    <div className="mx-3">
                        <p>Final token</p>
                        {/*
  *1. get destination chain and read mapping of hex => domainID
  2. find out avaialble token addresses for present chain from constants contract
  */}
                        <DropdownWidget menuItems={useAddress} sendData={getContractAddressData} />
                    </div>

                    <div className="mx-3">
                        <p>Address</p>
                        <DropdownWidget menuItems={useAddress} sendData={getContractAddressData} />
                    </div>
                </div>
            </div>

            <div>
                <button className="bg-black p-6 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">Bounce</button>
            </div>
        </div>
    );
};

export default BounceWidget;
