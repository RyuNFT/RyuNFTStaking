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

  // const stakingContractFactory = await ethers.getContractFactory("RyuNFTStaking");
  // stakingContract = await stakingContractFactory.deploy(`0x13d933EB47F41cBC0687376622D03A8Da10fEaB6`, `0x0FC468c8E2003C0e6Ab0e60DBf02b01ce27B4c7f`);
  // await stakingContract.deployed();
  // await tokenContract.setStakingAddress(stakingContract.address);

  // const nft2ContractFactory = await hre.ethers.getContractFactory("Ryu_V2");
  // nftContract = await upgrades.upgradeProxy(nftContract.address, nft2ContractFactory, {});


  const ryuFactory = await ethers.getContractFactory("Ryu");
  ryu = await ryuFactory.deploy();
  const res = await ryu.deployed();
  console.log("--> ", res.address);


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