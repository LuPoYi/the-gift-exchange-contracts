// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    uint8 private _customDecimals;

    constructor(
        string memory name,
        string memory symbol,
        uint8 customDecimals
    ) ERC20(name, symbol) {
        _customDecimals = customDecimals;
        _mint(msg.sender, 1000000 * 10**uint256(_customDecimals));
    }

    function decimals() public view override returns (uint8) {
        return _customDecimals;
    }
}
