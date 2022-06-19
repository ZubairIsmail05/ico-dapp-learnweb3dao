const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { CRYPTO_DEVS_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
    // address of Crypto Devs NFT Contract
    const cryptoDevsNFTContract = CRYPTO_DEVS_NFT_CONTRACT_ADDRESS;

    const cryptoDevsTokenContract = await ethers.getContractFactory("CryptoDevToken");
    const deployedCryptoDevsTokenContract = await cryptoDevsTokenContract.deploy(cryptoDevsNFTContract);

    console.log("Crypto Dev Token Contract Address: ", deployedCryptoDevsTokenContract.address);
}

// Call the main function and catch if there is any error
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });