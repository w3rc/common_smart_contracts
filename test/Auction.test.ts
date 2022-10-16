import { ethers } from 'hardhat'

describe('Auction', () => {
  async function deployFixture() {
    const Auction = await ethers.getContractFactory('Lottery')
    const auction = await Auction.deploy()

    return { auction }
  }

  it('should not allow owner to place a bid', () => {})
  it('should allow to bid only if auction is running', () => {})
  it('should allow a minimum bid of 1 ether', () => {})
  it('should make the current sender the highest bidder if he is one', () => {})
  it('should keep the existing highest bidder if current sender is not the highest bidder', () => {})
  it('should emit an event when a bid is placed', () => {})
  it('should not allow funds to be withdrawn before auction ends', () => {})
  it('should allow owner to withdraw funds from highest bidder\'s account', () => {})
  it('should allow the highest bidder to wnly withdraw the excess bid', () => {})
  it('should allow other users to withdraw their funds', () => {})
  it('should revert if user has nothing to withdraw', () => {})
  it('should emit an event when a user has withdrawn his funds', () => {})
  it('should log the highest bidder and bid', () => {})
  it('should inform the length of the auction', () => {})
})
