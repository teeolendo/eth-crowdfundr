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

    struct Contributions {
        address contributor;
        address amount;
    }
    
    /// @dev Denotes the various states of a project.
    enum ProjectStatus {
       Open,
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
    mapping (address => uint) contributors;
    mapping(uint256 => address) private _tiers;
    mapping (address => uint) public contributions;
    uint public idCounter = 0;
    uint public projectBalance;

    event ContributionReceived(address contributor, uint amount, uint projectBalance);
    event ContributorStatusUpdated(address creator, string contributorStatus);
    event ProjectSuccess(address creator, uint projectBalance);
    event ProjectTerminated(address creator, uint projectBalance);
    event CreatorPaid(address creator, uint amount, uint projectBalance);


    /**
     *  @dev Creates an instance of `Project`
     */
    constructor(
        address payable _projectCreator,
        string memory _projectName,
        uint _projectGoal
    ) {
        projectName = _projectName;
        projectCreator = _projectCreator;
        projectGoal = _projectGoal;
        projectStatus = ProjectStatus.Open;
        projectExpiryDate = block.timestamp + 30 days;
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
    modifier projectState(ProjectStatus _projectStatus) {
        require(projectStatus == _projectStatus);
        _;
    }

    /**
     * @dev Process contribution when a user send a contribution.
     */ 
    function contribute() external payable projectState(ProjectStatus.Open) returns (uint256) {
        require(msg.sender != address(0),  "Address not found");
        require(msg.value >= 0.01 ether, "0.01 ether is the minimum contribution required");
        contributions[msg.sender] += msg.value;
        projectBalance += msg.value;
        ContributorTier contributorTier = ContributorTier.Bronze;
        if(msg.value >= 0.25 ether || msg.value < 1 ether){
            contributorTier = ContributorTier.Silver;
        } else if(msg.value >= 1 ether) {
            contributorTier = ContributorTier.Gold;
        }
        emit ContributionReceived(msg.sender, msg.value, projectBalance);
        uint token = _mint(msg.sender, contributorTier);
        _updateProjectStatus();
        return token;
    }

    /**
     * @dev Process contribution when a user send a contribution.
     * @notice Call this function to get your money back.
     */ 
    function refund() external payable projectState(ProjectStatus.Terminated) {
        require(contributions[msg.sender] > 0, "You have no funds stored for this campaign");
        uint amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        projectBalance -= msg.value;
        (bool sent, ) = msg.sender.call{value:amount}("");
        require(sent, "Refund failed");
    }

    /**
     * @dev Allows the creator to withdraw funds once the project meets its goal.
     */
    function withdraw() external payable projectState(ProjectStatus.Successful) isProjectCreator {
        require(msg.value < projectBalance, "Value exceeds total project balance");
        projectBalance -= msg.value;
        (bool sent, ) = msg.sender.call{value:msg.value}("");
        require(sent, "Unable to Withdraw");
        emit CreatorPaid(msg.sender, msg.value, projectBalance);
    }

    /**
     * @dev Allows only the creator to terminate the project.
     */
    function requestTerminate() external projectState(ProjectStatus.Open) isProjectCreator {
        _terminateProject();
    }

    /**
     * @dev Returns the address the of owner if they hold a token.
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tiers[tokenId];
        require(owner != address(0), "No token for that address");
        return owner;
    }

    /**
     * @dev Returns the type of token the holder has.
     */
    function getTokenType(uint tokenId) public pure returns (uint8){
        return uint8(tokenId >> 1);
    }

    /**
     * @dev Update Project Status based on the Project Goal and Project Expiry Date
     */ 
    function _updateProjectStatus() internal {
        if(projectBalance >= projectGoal){
            projectStatus = ProjectStatus.Successful;
            emit ProjectSuccess(projectCreator, projectBalance);
        } else if (projectExpiryDate >= block.timestamp) {
           _terminateProject();
        }
    }

    /**
     * @dev Internal method to update project status to terminated.
     */
    function _terminateProject() internal {
        projectStatus = ProjectStatus.Terminated;
        emit ProjectTerminated(projectCreator, projectBalance);
    }

    /**
     * @dev Mint NTFs based on category
     */
    function _mint(address to, ContributorTier contributorTier) internal returns (uint256) {
        require(to != address(0),  "Address not found");
        uint tokenId = (idCounter << 1) + uint(contributorTier);
        _tiers[tokenId] = to;
        idCounter += 1;
        return tokenId;
    }
}

    
