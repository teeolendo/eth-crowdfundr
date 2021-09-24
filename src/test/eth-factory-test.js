const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EthStarter", function () {
  it("Should return a new list of projects", async function () {
    const [account1, account2, account3] = await ethers.getSigners()
    const EthProject = await ethers.getContractFactory("EthStarter")
    const ethStarter = await EthProject.deploy()
    await ethStarter.deployed();
    

    const newProject = await ethStarter.createProject("Fund a Bike", 4)
    await newProject.wait();
    await expect(newProject).to.emit(ethStarter, 'ProjectStarted')
    await expect(await newProject.showProjects().length).to.deep.equal(1);
    
  });
});