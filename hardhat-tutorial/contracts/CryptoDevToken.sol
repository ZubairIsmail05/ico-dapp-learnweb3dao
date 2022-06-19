// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    // price of 1 Crypto Dev token
    uint256 public constant tokenPrice = 0.001 ether;

    uint256 public constant tokensPerNFT = 10 * 10**18;

    // max supply of CD tokens is 10000
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    // CryptoDevs contract instance
    ICryptoDevs CryptoDevsNFT;

    // tracks which token Ids have been claimed
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    // mints 'amount' number of Crypto Dev Tokens
    function mint(uint256 amount) public payable {
        // amount of ether that needs to be sent to mint desired amount of CD tokens
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect");
        // number of minted tokens cannot exceed total supply
        uint256 amountWithDecimals = amount * 10**18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the max total supply available"
        );

        // mint CD tokens to user
        _mint(msg.sender, amountWithDecimals);
    }

    // Mints tokens for Crypto Dev NFT holders
    function claim() public {
        address sender = msg.sender;
        // Get number of Crypto Devs held by user
        uint256 balance = CryptoDevsNFT.balanceOf(sender);
        // user must hold a Crypto Dev NFT to claim CD tokens
        require(balance > 0, "Must hold a Crypto Dev NFT");
        // keeps track of number of unclaimed token Ids
        uint256 amount = 0;
        // get token Id of owner at a specific index
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            // if token Id has not been claimed, increase amount
            if (!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        // if all token Ids have been claimed, revert transaction
        require(amount > 0, "You have already claimed all the tokens");
        _mint(msg.sender, amount * tokensPerNFT);
    }

    // withdraws all ETH and tokens from contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
