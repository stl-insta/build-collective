pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./ProjectFactory.sol";

contract BountyFactory is ProjectFactory {
    Bounty[] public bounties;
    Fix[] public fixes;

    mapping(uint => uint) private fixToBounty;
    mapping(uint => uint) private bountyToProject;

    event NewBounty(uint id, string name, uint reward, BountyStatus status);
    event NewFix(uint id, string proposition);

    enum BountyStatus {
        Fixed,
        InProgress
    }

    struct Bounty {
        string name;
        uint reward;
        BountyStatus status;
    }

    struct Fix {
        address owner;
        string proposition;
    }

    function createBounty(uint _projectId, string calldata _name, uint _reward)
    external
    {
        // Project has balance
        require(projects[_projectId].balance >= _reward);

        projects[_projectId].balance -= _reward;

        bounties.push(Bounty(_name, _reward, BountyStatus.InProgress));
        uint id = bounties.length - 1;

        bountyToProject[id] = _projectId;

        emit NewBounty(id, _name, _reward, BountyStatus.InProgress);
    }

    function createFix(uint _bountyId, string calldata _proposition)
    external {
        fixes.push(Fix(msg.sender, _proposition));
        uint id = fixes.length;

        fixToBounty[id] = _bountyId;

        emit NewFix(id, _proposition);
    }

    function acceptFix(uint _fixId)
    external {
        uint bountyId = fixToBounty[_fixId];
        uint projectId = bountyToProject[bountyId];

        // Only project owner
        require(projects[projectId].owner == msg.sender);

        // Active project
        require(projects[projectId].active);

        // InProgress Bounty
        require(bounties[bountyId].status == BountyStatus.InProgress);

        users[fixes[_fixId].owner].balance += bounties[bountyId].reward;
        bounties[bountyId].status = BountyStatus.Fixed;
    }
}