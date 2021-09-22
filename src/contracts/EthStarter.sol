//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract EthStarter {
    
    
    
    constructor() {
        //TODO: Add Initial values
    }
}


/// @title EthStarter Project
/// @author Olendolorian
/// @notice This contract is used to manage the state of EthStarter Projects
/// @dev All function calls are currently implemented without side effects
contract Project {
    //create a project
    //view project status
    //project address
    //return all projects
    
    enum ProjectStatus {
       Open,
       Expired,
       Successful,
       Terminated
    }
    /// Initialize all projects to have a default status of Open 
    ProjectStatus public projectStatus = ProjectStatus.Open;

    string public projectName;
    address payable public projectCreator;
    uint public projectGoal;
    uint public endDate;
    uint public projectBalance;
    mapping (address => uint) contributors;

    /**
        Creator
        StartDate
        EndDate
        Project Balance
     */
    constructor(
        string memory _projectName,
        address payable _projectCreator,
        uint _projectGoal
    ) {
        //TODO: Add Initial values
        projectName = _projectName;
        projectCreator = _projectCreator;
        projectGoal = _projectGoal;
    }
    
}
