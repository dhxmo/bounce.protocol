import React, { useState, useEffect } from "react";
import { Radio } from "@material-tailwind/react";
import { ethers, BigNumber } from "ethers";
import { useRouter } from "next/router";

import { DropdownWidget } from "./index";
import { validChains, bounceTo, LPAddresses, VaultAddresses, chainDomainID, GOERLI_RPC_URL, MUMBAI_RPC_URL } from "../utils/index";

import { BOUNCE_ADDRESS, BOUNCE_ABI, BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI, BOUNCE_RECEIVER_ADDRESS } from "../config";

const ProtocolBounceWidget = () => {
    const router = useRouter();

    const [contract, setContract] = useState();
    const [bounceContract, setBounceContract] = useState();
    const [signer, setSigner] = useState();

    const [inputTokensList, setInputTokensList] = useState([]);
    const [outputTokensList, setOutputTokensList] = useState([]);

    const [inputValue, setInputValue] = useState(0);
    const [srcToken, setSrcToken] = useState("");

    const [targetChain, setTargetChain] = useState("");
    const [slippage, setSlippage] = useState(0);

    const [contractTo, setContractTo] = useState("");

    const [destToken, setDestToken] = useState("");

    // contracts used in a protocol/lp/vault
    const [useAddress, setUseAddress] = useState([]);

    const [contractCalldata, setContractCalldata] = useState("");

    // prevent infinite render
    useEffect(() => {
        async function getContract() {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            setSigner(provider.provider.selectedAddress);

            let _contract = new ethers.Contract(BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI, provider);
            let _bounce = new ethers.Contract(BOUNCE_ADDRESS, BOUNCE_ABI, provider);

            setContract(_contract);
            setBounceContract(_bounce);
        }

        getContract();
    }, []);

    async function getCallData() {
        try {
            const x = await contract.getVaultCalldata(contractTo);

            if (x.length == 0) {
                const y = await contract.getProtocolCalldata(contractTo);

                if (y.length == 0) {
                    const z = await contract.getLPCalldata(contractTo);
                    setContractCalldata(z);
                }

                setContractCalldata(y);
            }

            setContractCalldata(x);
        } catch (e) {
            console.log(e);
        }
    }

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

    async function inputTokens() {
        //                     get input tokens list
        const InputTokens = [];

        const chainID = window.ethereum.chainId;
        const domainID = BigNumber.from(chainDomainID[chainID]);

        const addresses = await contract.getApprovedTokens(domainID);
        const names = await contract.getApprovedTokenSymbols(domainID);

        for (let i = 0; i < names.length; i++) {
            InputTokens.push({
                type: names[i],
                key: addresses[i],
            });
        }

        setInputTokensList(InputTokens);
    }

    async function outputTokens() {
        if (!targetChain) {
            window.alert("Please select a target chain");
        } else {
            const OutputTokens = [];

            const domainID = BigNumber.from(chainDomainID[targetChain]);

            const addresses = await contract.getApprovedTokens(domainID);
            const names = await contract.getApprovedTokenSymbols(domainID);

            for (let i = 0; i < names.length; i++) {
                OutputTokens.push({
                    type: names[i],
                    key: addresses[i],
                });
            }

            setOutputTokensList(OutputTokens);
        }
    }

    function handleInputChange(e) {
        // handle input chaage
        setInputValue(e.target.value);
    }

    function handleSlippageChange(e) {
        setSlippage(e.target.value);
    }

    function getInputTokenData(data) {
        setSrcToken(data.anchorKey);
    }

    function getChainData(data) {
        setTargetChain(data.anchorKey);
    }

    function getContractAddressData(data) {
        setContractTo(data.anchorKey);
    }

    function getOutputTokenData(data) {
        setDestToken(data.anchorKey);
    }

    async function bounce() {
        const receiverAddress = BOUNCE_RECEIVER_ADDRESS[targetChain];

        const inTokenValue = BigNumber.from(inputValue);

        const minAmt = inputValue - inputValue * slippage;
        const minAmt2Send = BigNumber.from(minAmt);

        // not able to dynamically generate relayer fee
        // const relayerFee = await estimateRelayerFee();

        const slip = BigNumber.from(slippage);
        //when sending data crosschain

        const _order = [
            srcToken,
            destToken,
            contractTo,
            receiverAddress,
            inTokenValue,
            minAmt2Send,
            0, // relayer fee - 0 for testnet
            slip,
            chainDomainID.destchainID,
        ];

        try {
            let tx = await bounceContract.BounceFrom(_order, contractCalldata);
            let x = await tx.wait();

            if (x.status == 1) {
                router.push("/");
            }
        } catch (e) {
            window.alert(e);
        }
    }

    return (
        <div className="rounded-lg bg-orange-100 shadow-md p-4 grid grid-cols-1 grid-rows-6 place-items-center">
            <div className="flex">
                <button onClick={inputTokens} className="bg-orange-100 p-6 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">
                    Get src approved tokens
                </button>

                <DropdownWidget menuItems={inputTokensList} sendData={getInputTokenData} />
                <input name="inputValue" type="number" value={inputValue} onChange={handleInputChange} className="mx-5" />
            </div>

            <div className="grid grid-cols-1 grid-rows-5 justify-items-center items-start place-content-start">
                <div className="flex items-center">
                    <p className="mx-6">Destination chain</p>
                    <DropdownWidget menuItems={validChains} sendData={getChainData} />
                </div>
                <div className="flex my-6">
                    <button onClick={outputTokens} className="bg-orange-100 p-6 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">
                        Get dest approved tokens
                    </button>
                    <div className="mx-3">
                        <p>Final token</p>
                        <DropdownWidget menuItems={outputTokensList} sendData={getOutputTokenData} />
                    </div>
                </div>
                <div className="flex items-center">
                    <p>slippage(%)</p>
                    <input name="slippage" type="number" value={slippage} onChange={handleSlippageChange} className="mx-5" />
                </div>
                <div className="grid grid-rows-1 grid-cols-3 gap-x-5 justify-items-center">
                    <button className="bg-black p-3 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6" onClick={protocols}>
                        Ready
                    </button>
                </div>
                <div className="my-6 flex items-center">
                    <div className="mx-3">
                        <p>Destination</p>
                        <DropdownWidget menuItems={useAddress} sendData={getContractAddressData} />
                    </div>
                    <div>
                        <button className="bg-black p-3 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6" onClick={getCallData}>
                            Set
                        </button>
                    </div>
                </div>
                <div>
                    <button className="bg-black p-6 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6" onClick={bounce}>
                        Bounce
                    </button>
                </div>
            </div>
        </div>
    );
};

export default ProtocolBounceWidget;
