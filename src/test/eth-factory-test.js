const { expect } = require("chai");
const { ethers } = require("hardhat");
const abi = require("../src/artifacts/contracts/EthProject.sol/EthProject.json").abi;

describe("EthStarter", () => {

  let ethStarter;
  let EthProject;
  let accounts;

  beforeEach( async () => {
    accounts = await ethers.getSigners()
    EthProject = await ethers.getContractFactory("EthStarter")
    ethStarter = await EthProject.deploy()
    await ethStarter.deployed();
  })
  
  it("belongs to the creator", async function () {
    await ethStarter.createProject("Fund a Bike", 4)
    console.log(await ethStarter.showProjects())
    expect(await ethStarter.showProjects()).to.equal([accounts[0].address])
  })

  // it("to emit a Project Started", async function () {
  //   await ethStarter.createProject("Fund a Bike", 4)
  //   expect(await ethStarter.to.emit(ethStarter, 'ProjectStarted'))
  // })
});