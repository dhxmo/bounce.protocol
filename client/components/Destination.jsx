import React from "react";
import Link from "next/link";

const Destination = () => {
    return (
        <div className="flex flex-col">
            <Link href="/protocol">
                <button className="bg-orange-100 my-3 p-3 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">
                    Protocol 
                </button>
            </Link>

            <Link href="/lp">
                <button className="bg-orange-100 my-3 p-3 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">
                    LPs
                </button>
            </Link>

            <Link href="/vault">
                <button className="bg-orange-100 my-3 p-3 shadow-lg shadow-slate-300 rounded-lg text-orange-400 mx-6">
                    Vaults
                </button>
            </Link>
          </div>
    )
}

export default Destination;
