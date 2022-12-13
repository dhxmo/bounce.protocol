import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import { DropdownWidget } from "./index";

import { validChains } from "../utils/index";

const Wallet = () => {
    const [walletAddress, setWalletAddress] = useState("");

    const [current, setCurrent] = useState("");
    const [target, setTarget] = useState("");

    async function getAccount() {
        // check if metamask exists
        if (window.ethereum) {
            console.log("wallet detected");

            // request accounts in metmask
            try {
                const accounts = await window.ethereum.request({
                    method: "eth_requestAccounts",
                });
                // set first wallet address as default
                //console.log(accounts[0]);
                setWalletAddress(accounts[0]);
            } catch (err) {
                console.log(err);
            }
        } else {
            console.log("wallet not detected");
        }
    }

    async function connectWallet() {
        if (typeof window.ethereum !== "undefined") {
            await getAccount();
        }
    }

    const getData = (data) => {
        setTarget(data.anchorKey);
    };

    async function switchNetwork() {
        await window.ethereum.request({
            method: "wallet_switchEthereumChain",
            params: [{ chainId: target }],
        });
        // refresh
        window.location.reload();
    }

    return (
        <div className="flex items-center space-around">
            <button onClick={() => connectWallet()} className="bg-orange-100 p-3 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">
                {walletAddress ? walletAddress.substring(0, 7) + "..." : "Connect Wallet"}{" "}
            </button>
            <DropdownWidget menuItems={validChains} sendData={getData} />
            <button onClick={() => switchNetwork()} className=" mx-6 bg-orange-100 p-3 shadow-lg shadow-slate-300 rounded-lg text-orange-400">
                Switch Network
            </button>
        </div>
    );
};

export default Wallet;
