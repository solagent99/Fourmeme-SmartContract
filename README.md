# four-meme-fork-infra

Skeleton repo for forking four.meme-style projects. Contains token, factory, and liquidity manager skeletons plus deployment/test scaffolding.

## Quick start
1. Install deps: `npm install`
2. Copy `.env.example` to `.env` and set PRIVATE_KEY/RPC_URL
3. Compile: `npx hardhat compile`
4. Run tests: `npx hardhat test`
5. Deploy locally or to testnet with `npx hardhat run --network <net> scripts/deploy.js`

## Next steps
- Implement Pair contract if you want a custom AMM
- Replace LiquidityManager router calls with the real router API of your target DEX (example: PancakeSwap router)
- Add Slither and fuzz tests, and pursue a formal audit before mainnet
