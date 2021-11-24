pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./BuildCollective.sol";

contract BountyFactory is BuildCollective {
    mapping(uint => uint) private bountyToProject;
    mapping(uint => uint) private fixToBounty;
    Bounty[] private bounties;
    Fix[] private fixes;

    event NewBounty(uint id, string name, string description, uint reward, BountyStatus status);
    event NewFix(uint id, string proposition);

    enum BountyStatus {
        Fixed,
        InProgress
    }

    struct Bounty {
        string name;
        string description;
        uint reward;
        BountyStatus status;
    }

    struct Fix {
        address user;
        string proposition;
    }

    function _createBounty(
        string memory _name,
        string memory _description,
        uint _reward
    ) public {
        uint id = bounties.push(Bounty(_name, _description, _reward, BountyStatus.InProgress)) - 1;
        emit NewBounty(id, _name, _description, _reward, BountyStatus.InProgress);
    }

    function _createFix(string memory _proposition) public {
        uint id = fixes.push(Fix(msg.sender, _proposition)) - 1;
        emit NewFix(id, _proposition);
    }
}