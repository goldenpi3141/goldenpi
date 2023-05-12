// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GoldenPi is ERC20, Ownable {
    bool public limited;
    uint256 public maxHolding;
    uint256 public minHolding;
    address public pancakeswap;

    constructor() ERC20("GoldenPi", "GOPI") {
        _mint(msg.sender, 314159265358979 * 10 ** decimals());
    }


    function pancakeSwapLimit(bool _limited, address _pancakeswap, uint256 _maxHolding, uint256 _minHolding) external onlyOwner {
        limited = _limited;
        pancakeswap = _pancakeswap;
        maxHolding = _maxHolding;
        minHolding = _minHolding;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) override internal virtual {
        if (pancakeswap == address(0)) {
            require(from == owner() || to == owner(), "trading is not started");
            return;
        }

        if (limited && from == pancakeswap) {
            require(balanceOf(to) + amount <= maxHolding && balanceOf(to) + amount >= minHolding, "Forbid");
        }
    }
}

