import React, { useState } from "react";
import Image from "next/image";

import images from "../assets";
import { List } from "./index";

import { useAccount, useConnect, useDisconnect } from "wagmi";
import { InjectedConnector } from "wagmi/connectors/injected";

const Navbar = () => {
    const { address, isConnected } = useAccount();
    const { connect } = useConnect({
        connector: new InjectedConnector(),
    });
    const { disconnect } = useDisconnect();

    return (
        <div>
            <div className="flex justify-around items-center">
                <div className="flex space-between mx-6">
                    <div>
                        <Image src={images.logo} alt="logo" width={50} height={50} />
                    </div>
                </div>

                {isConnected ? (
                    <div className="p-4">
                        Connected to {address.substring(0,5) + "..."}
                        <button className="bg-grey p-4 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6" onClick={() => disconnect()}>
                            Disconnect
                        </button>
                    </div>
                ) : (
                    <button onClick={() => connect()} className="bg-grey p-6 shadow-lg shadow-slate-300 rounded-lg text-orange-400">
                        Connect Wallet
                    </button>
                )}
            </div>
        </div>
    );
};

export default Navbar;
