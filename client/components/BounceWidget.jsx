import React, { useState } from "react";
import { DropdownWidget } from "./index";

import { validChains, bounceTo, ProtocolAddresses, LPAddresses, VaultAddresses } from "../utils/index";

const BounceWidget = ({ constantsContract }) => {
    const [targetChain, setTargetChain] = useState("");
    const [bounceToType, setBounceToType] = useState("");
    const [useAddresses, setUseAddresses] = useState("");
    const [contractAddress, setContractAddress] = useState("");

    const getChainData = (data) => {
        setTargetChain(data.anchorKey);
    };

    const getBounceToData = (data) => {
        setBounceToType(data.anchorKey);

        switch (data.anchorKey) {
            case "1":
                setUseAddresses(ProtocolAddresses);
                break;
            case "2":
                setUseAddresses(LPAddresses);
                break;
            case "3":
                setUseAddresses(VaultAddresses);
                break;
        }
    };

    const getContractAddressData = (data) => {
        setContractAddress(data.anchorKey);
    };

    return (
        <div className="bg-gray-100 shadow-md min-h-fit p-10">
            <div className="flex items-center">
                <input type="number" />
            </div>

            <div className="grid grid-cols-3 align-center my-6 gap-x-6">
                {/*
                 * dropdown for destination chain
                 */}
                <DropdownWidget menuItems={validChains} sendData={getChainData} />
                {/*
                 * dropdown for protocol, LP or vault selection
                 */}
                <DropdownWidget menuItems={bounceTo} sendData={getBounceToData} />
                {/*
                 * which specific protocol/LP/vault. this will query constants contract
                 */}
                <DropdownWidget menuItems={useAddresses} sendData={getContractAddressData} />
            </div>

            <div>
                <button onClick={() => bounce()} className="bg-grey p-6 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">
                    Bounce
                </button>
            </div>
        </div>
    );
};

export default BounceWidget;
