import React from "react";
import { DropdownWidget } from "./index";

const BounceWidget = ({ constantsContract }) => {
    return (
        <div className="bg-gray-100 shadow-md min-h-fit p-10">
            <div className="flex items-center">
                <input type="number" />
            </div>

            <div className="flex items-center space-around my-6">
                {/*
                  *<DropdownWidget />
                  */}
                {/*
                  *<DropdownWidget />
                  *<DropdownWidget />
                  */}
            </div>
        </div>
    );
};

export default BounceWidget;
