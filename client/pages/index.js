import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import Web3Modal from "web3modal";
import { BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI } from "../config";

import { BounceWidget } from "../components/index";

export default function Home() {
    const [constantsContract, setConstantsContract] = useState();

    useEffect(() => {
        // function to get contract address and update state
        async function getContract() {
            const provider = new ethers.providers.Web3Provider(window.ethereum);

            // polygon mainnet
            // const provider = new ethers.providers.JsonRpcProvider('https://rpc-mainnet.maticvigil.com')

            // polygon testnet
            // const provider = new ethers.providers.JsonRpcProvider('https://rpc-mumbai.maticvigil.com');

            const signer = provider.getSigner();

            //let _contract = new ethers.Contract(BOUNCE_CONSTANTS_ADDRESS, BOUNCE_CONSTANTS_ABI, signer);
            //setConstantsContract(_contract);
        }

        getContract();
    });
    return (
        <div className="grid h-screen place-items-center">
            <BounceWidget constants={constantsContract} />
        </div>
    );
}
