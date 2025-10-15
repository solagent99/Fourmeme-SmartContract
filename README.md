# 🐸 Four Meme Fork — Smart Contracts Infrastructure

A modular, PancakeSwap-compatible token and liquidity infrastructure for meme or community projects.  
This repository provides a clean foundation to deploy and manage ERC-20 tokens with optional fees, liquidity hooks, and router adapters that integrate seamlessly with PancakeSwap v2-style routers.

---

## 🤝 Support/Contact
If you have any question or something, feel free to reach out me anytime via telegram, discord or twitter.
<br>
#### 🌹 You're always welcome 🌹

Telegram: [@Leo](https://t.me/shinnyleo0912) <br>
Discord: [@Leo](https://discord.com/users/695754747843444738) <br>

---


## 📦 Overview

**Core Components**
| Contract | Description |
|-----------|--------------|
| `Token.sol` | ERC-20 token with optional transfer fees, pausable transfers, and ERC20 rescue function. |
| `Factory.sol` | Deploys and registers new tokens under a unified registry for governance or analytics. |
| `LiquidityManager.sol` | Ownable contract that interfaces with a router (PancakeSwap-like) to add liquidity. Supports both ERC20–ERC20 and ERC20–BNB pairs. |
| `RouterAdapter.sol` | Adapter for PancakeSwap or Uniswap-style routers. Provides `addLiquidity` and `addLiquidityETH` forwarding. |
| `PairMock.sol` | Lightweight testing stub mimicking an AMM pair. |
| `MockRouter.sol` | Deterministic test router used in Hardhat tests (no real token transfers). |

**Optional Integrations**
- Router adapter can point to any AMM router that matches Pancake/Uniswap V2 ABI.
- LiquidityManager easily extends to handle LP token staking, buyback, or treasury logic.

---


Absolutely — here’s a **professional, developer-ready `README.md`** for your **Four Meme Fork (PancakeSwap-compatible)** project.
It’s designed to look like a real GitHub README for a modern Solidity project, with deploy/test instructions, architecture overview, and security notes.

---

## ⚙️ Setup & Installation

```bash
# 1. Clone this repository
git clone https://github.com/YOUR_USERNAME/four-meme-fork.git
cd four-meme-fork

# 2. Install dependencies
npm install

# 3. Compile smart contracts
npx hardhat compile

# 4. Run tests
npx hardhat test
````

---

## 🚀 Deployment

### Example: Deploy Token + LiquidityManager on BSC Testnet

1. Create `.env` file:

   ```bash
   PRIVATE_KEY=0xYOUR_PRIVATE_KEY
   RPC_URL=https://bsc-testnet.publicnode.com
   ```

2. Edit `scripts/deploy.js` (example snippet):

   ```js
   const router = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"; // PancakeSwap V2 router (Testnet)

   async function main() {
     const Token = await ethers.getContractFactory("Token");
     const token = await Token.deploy("Frog Token", "FROG", ethers.parseUnits("1000000000", 18), deployer.address);
     await token.waitForDeployment();

     const Manager = await ethers.getContractFactory("LiquidityManager");
     const manager = await Manager.deploy(router);
     await manager.waitForDeployment();

     console.log("Token:", token.target);
     console.log("LiquidityManager:", manager.target);
   }
   ```

3. Deploy:

   ```bash
   npx hardhat run scripts/deploy.js --network bscTestnet
   ```

---

## 💧 Adding Liquidity

### ERC20–ERC20 Pair

```solidity
manager.addLiquidity(
  tokenA,
  tokenB,
  amountA,
  amountB,
  receiver
);
```

### ERC20–BNB Pair

```solidity
manager.addLiquidityETH{value: bnbAmount}(
  token,
  tokenAmount,
  tokenMin,
  bnbMin,
  receiver,
  block.timestamp + 900
);
```

---

## 🧪 Testing

Uses [Hardhat](https://hardhat.org/) and [Chai](https://www.chaijs.com/).

```bash
npx hardhat test
```

Example output:

```
  Token - fee, pause, rescue
    ✓ mints initial supply to deployer
    ✓ applies transfer fee when configured
    ✓ pause prevents transfers
    ✓ rescueERC20 transfers tokens back to owner

  LiquidityManager integration (MockRouter)
    ✓ calls router.addLiquidity
    ✓ allows replacing router and continues to work
```

---

## 🔐 Security & Audit Checklist

* [ ] Add proper slippage / deadline checks for liquidity operations.
* [ ] Validate router addresses and token approvals before deployment.
* [ ] Conduct independent audit for fee logic, pause/rescue mechanisms, and liquidity management.
* [ ] Run static analysis (`slither`, `mythril`) before mainnet deployment.
* [ ] Ensure deployer private key and `.env` are **never** committed to version control.

---

## 🪶 License

MIT © 2025 — Open-source under permissive terms.
You are free to fork, modify, and deploy responsibly.

---

## 🤝 Contributions

Pull requests are welcome.
If you plan to extend features (e.g., staking, reflection, governance hooks), please open a discussion first.

---

## 📚 References

* [PancakeSwap V2 Router Docs](https://docs.pancakeswap.finance/code/smart-contracts/pancakeswap-exchange/router-v2)
* [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts)
* [Hardhat](https://hardhat.org/getting-started/)

```

