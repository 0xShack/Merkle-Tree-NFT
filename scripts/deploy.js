async function main() {
    // We get the contract to deploy
    const NFT = await ethers.getContractFactory("MerkleNFT");
    const nft = await NFT.deploy();
  
    console.log("NFT deployed to:", nft.address);
}
  
main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });