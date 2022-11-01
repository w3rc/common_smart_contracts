import { ethers } from 'hardhat'

async function main() {
  const Auction = await ethers.getContractFactory('Auction')
  const auction = await Auction.deploy()

  await auction.deployed()

  console.log(`Auction smart contract deployed to ${auction.address}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
