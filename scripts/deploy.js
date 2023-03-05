// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const { utils } = require("ethers");
async function main() {
  const baseTokenURI = "https://ipfs.io/ipfs//QmNxvxJCz9ByuDpL4rK3ZBER1NPYEmQw1MJoThb1tYdSzE/";
  // Get owner/deployer's wallet address
  const [owner] = await hre.ethers.getSigners();

  // Get contract that we want to deploy
  const contractFactory = await hre.ethers.getContractFactory("NFTCollectible");

  // Deploy contract with the correct constructor arguments
  const contract = await contractFactory.deploy(baseTokenURI);

  // Wait for this transaction to be mined
  await contract.deployed();

  // Get contract address
  console.log("Contract deployed to:", contract.address);
  
  
  await hre.run("verify:verify", {
    address: contract.address,
    contract: "contracts/NFTCollectible.sol:NFTCollectible",
    constructorArguments: [baseTokenURI]
  });
  //testing
  // Reserve NFTs
  let txn = await contract.reserveNFTs();
  await txn.wait();
  console.log("3 NFTs have been reserved");
  /*
  // Mint 3 NFTs by sending 0.03 ether
  txn = await contract.mintNFTs(3, { value: utils.parseEther('0.03') });
  await txn.wait()

  // Get all token IDs of the owner
  let tokens = await contract.tokensOfOwner(owner.address)
  console.log("Owner has tokens: ", tokens);
  */


  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const unlockTime = currentTimestampInSeconds + 60;

  // const lockedAmount = hre.ethers.utils.parseEther("0.001");

  // const Lock = await hre.ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  // await lock.deployed();

  // console.log(
  //   `Lock with ${ethers.utils.formatEther(
  //     lockedAmount
  //   )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
  // );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
