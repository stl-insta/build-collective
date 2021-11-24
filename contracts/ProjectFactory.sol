pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./BuildCollective.sol";

contract ProjectFactory is BuildCollective {
    mapping(address => uint) private contributorToProject;
    Project[] private projects;

    event NewProject(uint id, string name, string description, string url, uint balance);

    struct Project {
        string name;
        string description;
        string url;
        uint balance;
    }

    function _createProject(
        string memory _name,
        string memory _description,
        string memory _url
    ) public {
        uint id = projects.push(Project(_name, _description, _url, 0)) - 1;
        emit NewProject(id, _name, _description, _url, 0);
    }
}