import { ethers } from 'hardhat'

async function main() {
  const CrowdFunding = await ethers.getContractFactory('CrowdFunding')
  const crowdFunding = await CrowdFunding.deploy(1000, 120000);

  await crowdFunding.deployed()

  console.log(`CrowdFunding smart contract deployed to ${crowdFunding.address}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
