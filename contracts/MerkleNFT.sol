// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./MerkleTree.sol";

/**
 * @dev NFT collection that stores metadata on-chain and uses a Merkle Tree
 * to store mint data.
 */
contract MerkleNFT is ERC721URIStorage, Ownable {
    using Strings for uint256;

    uint256 mintCount;
    uint256 maxAmount = 100;

    bytes32 root;

    MerkleTree mt;

    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("Merkle Token", "MERK") {
        mintCount = 0;
        mt = new MerkleTree(maxAmount);
    }

    /**
     * @dev Mints an NFT from the collection and updates Merkle Tree
     */
    function mintNFT(address _to) public {
        require(mintCount + 1 <= maxAmount, "all tokens are minted");
        mintCount++;
        _mint(_to, mintCount);
        _setTokenURI(mintCount);
        updateTree(_to, mintCount, _tokenURIs[mintCount]);
    }

    function tokenURI(uint256 tokenID)
        public
        view
        override
        returns (string memory)
    {
        return _tokenURIs[tokenID];
    }

    function _setTokenURI(uint256 tokenID)
        internal
    {
        bytes memory dataURI = abi.encodePacked(
            '{',
                ' "name":  "Merkle Token #', tokenID.toString(), '"',
                ' "description": "An exercise in using Merkle Trees to store data"',
            '}'
        );
        _tokenURIs[tokenID] = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function updateTree(
        address _receiver, 
        uint256 _tokenId, 
        string memory _tokenURI
        ) internal 
    {
        bytes32 hashed = keccak256(
            abi.encodePacked(
                msg.sender, 
                _receiver,
                _tokenId,
                _tokenURI
            )
        );
        root = mt.add(hashed);
    }

    function getRoot() public view returns (bytes32) {
        return root;
    }

}