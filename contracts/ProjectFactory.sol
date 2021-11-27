// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./BuildCollective.sol";


contract ProjectFactory is BuildCollective {
    mapping (uint => address[]) public projectToContributors;

    Project[] public projects;

    event NewProject(uint projectId, string name, uint balance);
    event NewSponsor(uint projectId, uint amount);
    event NewContributor(uint contributorId, address user);

    struct Project {
        string name;
        uint balance;
        address owner;
        bool active;
    }

    function createProject(string memory _name) 
    public 
    {
        projects.push(Project(_name, 0, msg.sender, true));
        uint id = projects.length - 1;
        emit NewProject(id, _name, 0);
    }


    function sponsorProject(uint _id, uint _amount)
    public
    hasSold(_amount)
    isRegistered(msg.sender)
    {
        require(_amount > 0);
        require(projects[_id].active);

        projects[_id].balance += _amount;
        withdrawBalance(_amount);

        emit NewSponsor(_id, _amount);
    }

    function addContributor(uint _projectId, address _user)
    public
    isActive(_projectId)
    isRegistered(_user)
    {
        projectToContributors[_projectId].push(_user);
        emit NewContributor(_projectId, _user);
    }

    function getProject(uint id) 
    external view 
    returns (Project memory) {
        return projects[id];
    }

    function getProjects() 
    external view 
    returns (Project[] memory) {
        return projects;
    }

    function getProjectContributors(uint _projectId) 
    external view
    returns (address[] memory){
        return projectToContributors[_projectId];
    }

    modifier isActive(uint _id) {
        require(projects[_id].active);
        _;
    }
}