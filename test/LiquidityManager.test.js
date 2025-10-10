const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('LiquidityManager integration (MockRouter)', function () {
  let deployer;
  let LiquidityManager, manager;
  let MockRouter, mockRouter;
  let Token, tokenA, tokenB;

  beforeEach(async () => {
    [deployer] = await ethers.getSigners();

    // Deploy a couple of ERC20 tokens (reuse Token from contracts as simple ERC20)
    Token = await ethers.getContractFactory('Token');
    tokenA = await Token.deploy('A', 'A', ethers.parseUnits('10000', 18), deployer.address);
    await tokenA.deployed();
    tokenB = await Token.deploy('B', 'B', ethers.parseUnits('10000', 18), deployer.address);
    await tokenB.deployed();

    // Deploy MockRouter
    MockRouter = await ethers.getContractFactory('MockRouter');
    mockRouter = await MockRouter.deploy();
    await mockRouter.deployed();

    // Deploy LiquidityManager pointing at MockRouter
    LiquidityManager = await ethers.getContractFactory('LiquidityManager');
    manager = await LiquidityManager.deploy(mockRouter.target);
    await manager.deployed();
  });

  it('calls router.addLiquidity and emits LiquidityAdded with returned amounts', async function () {
    const amtA = ethers.parseUnits('100', 18);
    const amtB = ethers.parseUnits('200', 18);

    // Manager is owner (deployer) so call succeeds
    await expect(manager.addLiquidity(tokenA.target, tokenB.target, amtA, amtB, deployer.address))
      .to.emit(manager, 'LiquidityAdded')
      .withArgs(tokenA.target, tokenB.target, amtA, amtB, deployer.address);
  });

  it('allows replacing router and continues to work', async function () {
    // Deploy a second router and set it
    MockRouter = await ethers.getContractFactory('MockRouter');
    const mockRouter2 = await MockRouter.deploy();
    await mockRouter2.deployed();

    await manager.setRouter(mockRouter2.target);

    const amtA = ethers.parseUnits('10', 18);
    const amtB = ethers.parseUnits('10', 18);

    await expect(manager.addLiquidity(tokenA.target, tokenB.target, amtA, amtB, deployer.address))
      .to.emit(manager, 'LiquidityAdded')
      .withArgs(tokenA.target, tokenB.target, amtA, amtB, deployer.address);
  });
});
