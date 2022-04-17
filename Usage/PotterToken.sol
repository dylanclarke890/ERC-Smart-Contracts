// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ERC/ERC-721/ERC721.sol";
import "../ERC/ERC-721/extensions/ERC721Burnable.sol";
import "../ERC/ERC-721/extensions/ERC721URIStorage.sol";
import "../ERC/security/Pausable.sol";
import "../ERC/access/Ownable.sol";
import "../ERC/utils/Counters.sol";

contract PotterToken is ERC721, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("PotterToken", "PT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "://ipfs/SOMECID/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}