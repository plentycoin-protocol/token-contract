/* eslint-disable no-console */

import { ethers } from 'hardhat'

async function main() {
  const Plenty = await ethers.getContractFactory('Plenty')

  console.log('Starting deployments...')
  const plenty = await Plenty.deploy()
  await plenty.deployed()
  console.log('Test contract deployed to:', plenty.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
