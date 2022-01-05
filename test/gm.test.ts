import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('gm', function () {
  it('should get ward', async function () {
    const Lab = await ethers.getContractFactory('Lab')
    const lab = await Lab.deploy()
    await lab.deployed()
    const [s] = await ethers.getSigners()

    expect((await lab.wards(s.address)).toString()).to.equal('1')
  })
})
