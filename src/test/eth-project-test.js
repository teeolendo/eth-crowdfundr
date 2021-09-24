const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ethProject", function () {
  it("Check for contribution limit exceed", async function () {
    const [account1, account2, account3] = await ethers.getSigners()
    const EthProject = await ethers.getContractFactory("EthProject")
    const ethProject = await EthProject.deploy(account1, "Build MX1", 3)
    await ethProject.deployed();
    
    const contributionTrx1 = await ethProject.contribute({value: 1})
    const contributionTrx2 = await ethProject.connect(account2).contribute({value : 2})
    await contributionTrx1.wait();
    await contributionTrx2.wait();
    await expect(contributionTrx1).to.emit(ethProject, 'ContributionReceived').withArgs(account1, )
    await expect(await contributionTrx1.showProjects().length).to.deep.equal(1);
  });
});