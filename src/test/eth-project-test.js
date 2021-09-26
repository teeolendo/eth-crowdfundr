const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EthStarter", () => {
  let EthProject;
  let testProject;
  let account1, account2, account3;
  const projectName = "Test Project"
  const projectGoal = 4;

  beforeEach( async () => {
    [account1, account2, account3] = await ethers.getSigners()
    console.log(account1)
    EthProject = await ethers.getContractFactory("EthProject")
    testProject = await EthProject.connect(account1.address).deploy(account1, projectName, projectGoal)
    await testProject.deployed()
  })
  
  // describe("Contract", () => {
  //   it("belongs to the creator", async function () {
  //     expect(await testProject.creator).to.equal(account1)
  //   })
  // })
});