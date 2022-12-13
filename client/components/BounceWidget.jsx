import React, { useState, useEffect } from "react";
import { Radio, Select, Option } from "@material-tailwind/react";
import Web3Modal from "web3modal";
import { ethers } from "ethers";

import { DropdownWidget } from "./index";
import { validChains, bounceTo, LPAddresses, VaultAddresses } from "../utils/index";
import { BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI } from "../config";

const BounceWidget = ({ constantsContract }) => {
    const [contract, setContract] = useState();

    const [inputValue, setInputValue] = useState(0);
    const [targetChain, setTargetChain] = useState("");
    const [bounceToType, setBounceToType] = useState("");
    const [contractTo, setContractTo] = useState("");

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

    const handleInputChange = (e) => {
        setInputValue(e.target.value);
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

    return (
        <div className="bg-gray-100 shadow-md p-10 grid grid-cols-1 grid-rows-3 justify-items-center h-30">
            <div>
                <input name="inputValue" type="number" value={inputValue} onChange={handleInputChange} />
            </div>

           <div className="grid grid-cols-1 grid-rows-3 justify-items-center">
            {/*
              *<div className="flex flex-col">
              */}
                {/*
                 * dropdown for destination chain
                 */}
                <DropdownWidget menuItems={validChains} sendData={getChainData} />

                {/*
                 * dropdown for protocol, LP or vault selection
                 */}

                {/*
                 *<div className="grid gris-cols-1 gap-y-5">
                 */}
                <div>
                    <Radio id="protocol" name="type" label="Protocol" onClick={protocols} />
                    <Radio id="lp" name="type" label="LP" onClick={lps} />
                    <Radio id="vault" name="type" label="Vault" onClick={vaults} />
                </div>

                {/*
                 * which specific protocol/LP/vault. this will query constants contract
                 */}
                <DropdownWidget menuItems={useAddress} sendData={getContractAddressData} />
            </div>

            <div>
                <button className="bg-grey p-6 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">Bounce</button>
            </div>
        </div>
    );
};

export default BounceWidget;
