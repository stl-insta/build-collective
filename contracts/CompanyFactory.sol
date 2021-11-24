pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./BuildCollective.sol";

contract CompanyFactory is BuildCollective {
    struct Company {
        string name;
    }

    mapping(uint => uint) private memberToCompany;
    mapping(uint => address) private companyToOwner;

    Company[] private companies;

    event NewCompany(uint companyId, string name);
    event NewCompanyMember(uint userId, uint companyId);

    function createCompany(string memory _name) public returns (bool) {
        uint id = companies.push(Company(_name)) - 1;
        companyToOwner[id] = msg.sender;
        emit NewCompany(id, _name);
        return true;
    }

    function getCompanies() external view returns (Company[] memory) {
        return companies;
    }

    function addMember(uint _userId, uint _companyId) onlyOwner(_companyId, companyToOwner) external returns (bool) {
        // Check if the owner is trying to add himself as a member
        memberToCompany[_userId] = _companyId;
        emit NewCompanyMember(_userId, _companyId);
        return true;
    }
}