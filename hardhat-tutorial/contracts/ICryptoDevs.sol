// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface ICryptoDevs {
    // returns token ID owned by owner at a given index of its token list
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256 tokenId);

    // returns number of tokens in owner's account
    function balanceOf(address owner) external view returns (uint256 balance);
}
