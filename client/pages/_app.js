import "../styles/globals.css";

import { Navbar } from "../components/index.js";
import { WagmiConfig, createClient } from "wagmi";
import { getDefaultProvider } from "ethers";

const client = createClient({
    autoConnect: true,
    provider: getDefaultProvider(),
});

const MyApp = ({ Component, pageProps }) => (
    <div className="p-5 min-h-screen">
        <WagmiConfig client={client}>
            <Navbar />

            <Component {...pageProps} />
        </WagmiConfig>
    </div>
);

export default MyApp;
