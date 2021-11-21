pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./BuildCollective.sol";

contract CompanyFactory is BuildCollective {
    struct Company {
        string name;
    }

    mapping(address => uint) private memberToCompany;
    mapping(uint => address) private companyToOwner;

    Company[] private companies;

    event NewCompany(uint companyId, string name);

    function createCompany(string memory _name) public returns (bool) {
        uint id = companies.push(Company(_name)) - 1;
        companyToOwner[id]= msg.sender;
        emit NewCompany(id, _name);
        return true;
    }

    function getCompanies() public view returns (Company[] memory) {
        return companies;
    }
}