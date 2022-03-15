const main = async () => {
  let nftContract, tokenContract, stakingContract;
  let deployer, otherAccnt;

  [deployer] = await ethers.getSigners()

  // const nftContractFactory = await hre.ethers.getContractFactory('Ryu');
  // nftContract = await upgrades.deployProxy(nftContractFactory, [], { kind: 'uups', initializer: 'initialize' })
  // const res = await nftContract.deployed();
  // console.log(nftContract, res);

  // const tokenContractFactory = await ethers.getContractFactory("RyuToken");
  // tokenContract = await tokenContractFactory.deploy();
  // await tokenContract.deployed();

  const stakingContractFactory = await ethers.getContractFactory("RyuNFTStaking");
  stakingContract = await stakingContractFactory.deploy(`0x27f3404Af9a5C9cff488c2b02742a4C00460d728`, `0x9AD0a2aB35322A859013F28700D7247424462ba9`);
  await stakingContract.deployed();
  await tokenContract.setStakingAddress(stakingContract.address);

  // const nft2ContractFactory = await hre.ethers.getContractFactory("Ryu_V2");
  // nftContract = await upgrades.upgradeProxy(nftContract.address, nft2ContractFactory, {});


};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();