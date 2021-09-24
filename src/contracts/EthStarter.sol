//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./EthProject.sol";
import "hardhat/console.sol";

/**
 *
 * @title EthStarter
 * @author Olendolorian
 * @notice Factory contract that creates and maintains a list of projects.
 *
 */
contract EthStarter {

    EthProject[] private projects;

    event ProjectStarted(
        address contractAddress,
        address projectCreator,
        string projectName,
        uint256 projectGoal
    );
    
    /// @dev Creates new EthProjects.
    function createProject(
        string memory projectName,
        uint projectGoal
    )   external {
        EthProject newProject = new EthProject(payable(msg.sender), projectName, projectGoal);
        projects.push(newProject);
        emit ProjectStarted(
            address(newProject),
            msg.sender,
            projectName,
            projectGoal
        );
    }

    /** 
      * @dev Function to get all projects' contract addresses.
      * @return A list of all projects' contract addreses
      */
    function showProjects() external view returns(EthProject[] memory){
        return projects;
    }
}
