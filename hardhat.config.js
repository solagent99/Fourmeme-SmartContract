require('dotenv').config();
require('@nomiclabs/hardhat-ethers');

module.exports = {
  solidity: '0.8.20',
  networks: {
    hardhat: {},
    // add testnets in .env and here for convenience
  }
};
