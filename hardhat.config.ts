import { config as dotenvConfig } from 'dotenv'

dotenvConfig()

import 'hardhat-gas-reporter'
import '@typechain/hardhat'
import '@nomiclabs/hardhat-waffle'
import '@nomiclabs/hardhat-etherscan'
import 'hardhat-deploy'
import 'solidity-coverage'

import { NetworksUserConfig, HardhatUserConfig } from 'hardhat/types'

const PRIVATE_KEY = process.env.PRIVATE_KEY || ''
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const REPORT_GAS = Boolean(process.env.REPORT_GAS)

const networks: NetworksUserConfig = {
  hardhat: {},
  localhost: {},
  coverage: {
    url: 'http://127.0.0.1:8555', // Coverage launches its own ganache-cli client
  },
  testnet: {
    url: `https://data-seed-prebsc-1-s2.binance.org:8545/`,
    accounts: [PRIVATE_KEY],
  },
  mainnet: {
    url: `https://bsc-dataseed1.ninicoin.io/`,
    accounts: [PRIVATE_KEY],
  },
}

const config: HardhatUserConfig = {
  defaultNetwork: 'hardhat',
  solidity: {
    compilers: [
      {
        version: '0.8.0',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  gasReporter: {
    currency: 'USD',
    enabled: REPORT_GAS,
    showTimeSpent: true,
  },
  networks,
}

if (ETHERSCAN_API_KEY) {
  config.etherscan = {
    apiKey: ETHERSCAN_API_KEY,
  }
}

export default config
