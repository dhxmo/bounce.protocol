import { useEffect } from "react";
import { SSRProvider } from "@restart/ui/ssr";

import "../styles/globals.css";

import { Navbar } from "../components/index.js";

const MyApp = ({ Component, pageProps }) => {
    return (
        <div className="p-5 bg-black min-h-screen">
            <SSRProvider>
                <Navbar />
                <Component {...pageProps} />
            </SSRProvider>
        </div>
    );
};

export default MyApp;
