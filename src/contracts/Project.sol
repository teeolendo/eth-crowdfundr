//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

/**
 *
 * @title EthProject
 * @author Olendolorian
 * @notice This contract is used to manage the state of EthStarter Projects
 * @dev This contract is the core of EthStarter, it includes functions to allow for the full administration of a project by the project creator.
 *
 */

contract EthProject {

    struct Project {
        address creator;
        uint fundingGoal;
        string projectGoal;
        ProjectStatus projectStatus;
    }

    struct Contributions {
        address contributor;
        address amount;
    }
    
    /// @dev Denotes the various states of a project.
    enum ProjectStatus {
       Open,
       Expired,
       Successful,
       Terminated
    }

    /// @dev Denotes the contributor tiers. A contributor can only have one state. 
    enum ContributorTier {
        Gold,
        Silver,
        Bronze
    }
    
    ProjectStatus public projectStatus;
    string public projectName;
    address payable public projectCreator;
    uint public projectGoal;
    uint public projectExpiryDate;
    uint public projectBalance;
    mapping (address => uint) contributors;
    mapping (address => ProjectStatus) tiers;
    Project[] public projects;
    mapping (address => uint) public contributions;

    event ContributionReceived(address contributor, uint amount, uint projectBalance);
    event ContributorStatusUpdated(address creator, string contributorStatus);
    event ProjectSuccess(address creator, uint projectBalance);
    event ProjectExpired(address creator, uint projectBalance);
    event ProjectTerminated(address creator, uint projectBalance);
    event CreatorPaid(address creator, uint amount, uint projectBalance);


    /**
     *  @dev Creates an instance of `Project`
     */
    constructor(
        string memory _projectName,
        address payable _projectCreator,
        uint _projectGoal
    ) {
        projectName = _projectName;
        projectCreator = _projectCreator;
        projectGoal = _projectGoal;
        projectStatus = ProjectStatus.Open;
        projectExpiryDate = block.timestamp + 30 days;
        projectBalance = 0; 
    }

    /**
     * @dev Modifier to ensure that only certain functions can be accessed by the project creator.
     */
    modifier isProjectCreator() {
        require(msg.sender == projectCreator);
        _;
    }

    /**
     * @dev Modifier to ensure that only certain functions can be accessed by the project creator.
     */
    modifier projectIsActive() {
        require(projectStatus == ProjectStatus.Open);
        _;
    }

    /**
     * @dev Process contribution when a user send a contribution
     */ 
    function contribution() external payable projectIsActive {
        require(msg.value >= 0.01 ether, "0.01 ether is the minimum contribution required");
        contributions[msg.sender] += msg.value;
        projectBalance += msg.value;
        _updateProjectStatus();
    }

    /**
     * @dev Update Project Status based on the Project Goal and Project Expiry Date
     */ 
    function _updateProjectStatus() internal {
        if(projectBalance >= projectGoal){
            projectStatus = ProjectStatus.Successful;
            emit ProjectSuccess(projectCreator, projectBalance);
        } else if (projectExpiryDate >= block.timestamp) {
            projectStatus = ProjectStatus.Expired;
            emit ProjectExpired(projectCreator, projectBalance);
        }
    }
}
