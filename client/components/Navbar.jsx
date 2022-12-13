import React, { useState } from "react";
import Image from "next/image";

import images from "../assets";
import { Wallet } from './index';

const Navbar = () => {
    return (
        <div>
            <div className="flex justify-around items-center">
                <div className="mx-6">
                    <div>
                        <Image src={images.logo} alt="logo" width={50} height={50} />
                    </div>
                </div>

                <div>   
                    <Wallet />
                </div>
            </div>
        </div>
    );
};

export default Navbar;
