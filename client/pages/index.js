import React, { useState, useEffect } from "react";
import { useDispatch } from 'react-redux';

import { BounceWidget } from "../components/index";

export default function Home() {

    return (
        <div className="grid h-screen place-items-center">
            <BounceWidget />
        </div>
    );
}
