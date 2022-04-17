// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ERC/ERC-20/ERC20.sol";
import "../ERC/ERC-20/extensions/ERC20Burnable.sol";
import "../ERC/security/Pausable.sol";
import "../ERC/access/Ownable.sol";

contract PotterCoin is ERC20, ERC20Burnable, Pausable, Ownable {
    constructor() ERC20("PotterCoin", "PC") {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}