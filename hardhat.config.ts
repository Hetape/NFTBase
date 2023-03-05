// require("@nomicfoundation/hardhat-toolbox");
// require ('@typechain/hardhat')
// require ('@nomiclabs/hardhat-ethers')
// require ('@nomiclabs/hardhat-waffle')
// require ('hardhat-contract-sizer')
// require ('solidity-coverage')
// require ('hardhat-deploy')
// require ('@nomiclabs/hardhat-etherscan')
import '@typechain/hardhat'
import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-waffle'
import 'hardhat-contract-sizer'
import 'solidity-coverage'
import 'hardhat-deploy'
import '@nomiclabs/hardhat-etherscan'
require('dotenv').config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports =  {
  solidity: {
    version: '0.8.18',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks:{
    goerli:{
      url: process.env.GOERLI_NET_API_URL,
      accounts: [process.env.PRIVATE_KEY],
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
//npx hardhat compile
// npx hardhat verify 0x3bFc23A328C5979644a5b5CB1b9b92834f062075 https://ipfs.io/ipfs//QmNxvxJCz9ByuDpL4rK3ZBER1NPYEmQw1MJoThb1tYdSzE/ --network goerli