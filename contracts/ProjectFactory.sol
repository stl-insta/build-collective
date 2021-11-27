pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./BuildCollective.sol";


contract ProjectFactory is BuildCollective {
    mapping (uint => mapping(uint => address)) public projectToContributors;
    mapping (uint => User) public projectToUser;

    Project[] public projects;
    User[] public contributors;

    event NewProject(uint projectId, string name, uint balance);
    event NewSponsor(uint projectId, uint amount);
    event NewContributor(uint contributorId, address user);

    struct Project {
        string name;
        uint balance;
        address owner;
        bool active;
    }

    function createProject(
        string memory _name
    ) public {
        projects.push(Project(_name, 0, msg.sender, true));

        uint id = projects.length - 1;
        projectToUser[id] = user(msg.sender);

        emit NewProject(id, _name, 0);
    }


    function sponsorProject(
        uint _id, uint _amount
    )
    public
    hasSold(_amount)
    isRegistered(msg.sender)
    {
        require(_amount > 0);
        require(projects[_id].active);

        projects[_id].balance += _amount;
        substractBalance(_amount);

        emit NewSponsor(_id, _amount);
    }

    function addContributor(
        uint _id, address _user
    )
    public
    isActive(_id)
    isRegistered(_user)
    {
        contributors.push(user(_user));
        uint id = contributors.length - 1;

        projectToContributors[_id][id] = _user;

        emit NewContributor(id, _user);
    }

    modifier isActive(uint _id) {
        require(projects[_id].active);
        _;
    }
}