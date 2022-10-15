import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('Lottery', () => {
  async function deployFixture() {
    const Lottery = await ethers.getContractFactory('Lottery')
    const lottery = await Lottery.deploy()

    return { lottery }
  }

  it('should return a list of players who participated in the lottery', () => {})
  it('should add new players when he pays 1 ether', () => {})
  it('should only allow manager to see the contract balance', () => {})
  it('should only allow manager to pick a winner from a list of players', () => {})
  it('should only start picking winner if there is at least 3 players', () => {})
  it("should send all the balance in the contract to the winner's account", () => {})
  it('should reset the players list after lottery is over', () => {})
})
