import React, { useState, useEffect } from "react";
import { Dropdown } from "@nextui-org/react";

const DropdownWidget = ({ menuItems, sendData }) => {
    const [selected, setSelected] = useState("");
    const selectedValue = React.useMemo(() => Array.from(selected).join(", ").replaceAll("_", " "), [selected]);

    const handleChange = (e) => {
        setSelected(e);
        sendData(e);
    };

    return (
        <div>
            <Dropdown>
                <Dropdown.Button flat color="primary" css={{ tt: "capitalize" }}>
                    {selectedValue}
                </Dropdown.Button>
                <Dropdown.Menu aria-label="Single selection actions" disallowEmptySelection selectionMode="single" selectedKeys={selected} onSelectionChange={handleChange} items={menuItems}>
                    {(item) => <Dropdown.Item key={item.key}>{item.type}</Dropdown.Item>}
                </Dropdown.Menu>
            </Dropdown>
        </div>
    );
};

export default DropdownWidget;
