/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();
const { MN_API_URL, BS_API_URL, PRIVATE_KEY_OWNER, GO_API_URL, SEPOLIA_API_URL, ether_mai, Matic_mainnet} = process.env
module.exports = {
  solidity: "0.8.7",
  networks: {
    hardhat: {},
    mumbai: {
      url: MN_API_URL,
      accounts: [`0x${PRIVATE_KEY_OWNER}`],
    },
    localhost: {
      url: "http://127.0.0.1:7545"
    },
    
    ether: {
      url: ether_mai,
      accounts: [`0x${PRIVATE_KEY_OWNER}`], 
    },
    sepolia : {
      url: SEPOLIA_API_URL,
      accounts: [`0x${PRIVATE_KEY_OWNER}`],
    },

    Matic_mainnet : {
      url: Matic_mainnet,
      accounts: [`0x${PRIVATE_KEY_OWNER}`], 
    },

    bsc : {
      url : BS_API_URL,
      accounts: [`0x${PRIVATE_KEY_OWNER}`] 
    }
  },
  etherscan: {
    apiKey: process.env.BSCSCAN_API_KEY
  }
}