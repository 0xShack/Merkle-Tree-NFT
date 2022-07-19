// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Implementation of a merkle tree on-chain. Allows user to update and add
 * leaves to the tree and compute the root node. Compute the proof off-chain to save
 * gas and use openzeppelin's MerkleProof.sol to verify if a leaf is in the tree
 */
contract MerkleTree is Ownable {

    bytes32[] leaves;
    uint256 size;

    constructor(uint256 _size) {
        leaves = new bytes32[](_size);
        size = _size;
    }

    function add(bytes32 leaf) public onlyOwner returns (bytes32) {
        leaves.push(leaf);
        return getRoot();
    }

    function update(bytes32 leaf, uint256 index) public onlyOwner returns (bytes32) {
        leaves[index] = leaf;
        return getRoot();
    }

    function getRoot() 
        internal 
        view 
        returns (bytes32)
    {
        bytes32[] memory previous = leaves;
        bytes32[] memory next = new bytes32[](size / 2);
        uint256 n = size;
        uint256 index = 0;
        while (n > 1) {
            for (uint256 i = 0; i < n; i += 2) {

                next[index] = keccak256(
                    abi.encodePacked(
                        previous[i], previous[i + 1]
                    )
                );
                ++index;
            }
            previous = next;
            index = 0;
            n /= 2;
        }
        return previous[0];
    }

}