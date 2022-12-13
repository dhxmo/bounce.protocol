import { useEffect } from "react";

import "../styles/globals.css";

import { Navbar } from "../components/index.js";


const MyApp = ({ Component, pageProps }) => {

    return (
        <div className="p-5 min-h-screen">
            <Navbar />
            <Component {...pageProps} />
        </div>
    );
};

export default MyApp;
