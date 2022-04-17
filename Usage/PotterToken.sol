// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ERC/ERC-721/ERC721.sol";
import "../ERC/ERC-721/extensions/ERC721URIStorage.sol";
import "../ERC/ERC-721/extensions/ERC721Burnable.sol";
import "../ERC/security/Pausable.sol";
import "../ERC/access/Ownable.sol";
import "../ERC/utils/Counters.sol";

contract PotterToken is ERC721, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(string => uint) existingUris;

    constructor() ERC721("PotterToken", "PT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ifps://";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function isContentOwned(string memory uri) public view returns(bool) {
        return existingUris[uri] == 1;
    }

    function payToMint(address payable recipient, string memory metaDataUri) public payable whenNotPaused returns(uint256) {
        require(existingUris[metaDataUri] != 1, "NFT already minted");
        require(msg.value >= 0.05 ether, "NFT costs at least 0.05 ether");

        uint256 newItemId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        existingUris[metaDataUri] = 1;

        _mint(recipient, newItemId);
        _setTokenURI(newItemId, metaDataUri);

        return newItemId;
    }

    function count() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}