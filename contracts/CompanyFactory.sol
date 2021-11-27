pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./BuildCollective.sol";

contract CompanyFactory is BuildCollective {
    mapping(uint => address[]) companyToMembers;

    struct Company {
        string name;
        address owner;
    }

    Company[] private companies;

    event NewCompany(uint companyId, string name);
    event NewCompanyMember(uint companyId, address user);

    function createCompany(string memory _name) 
    public 
    {
        companies.push(Company(_name, msg.sender));
        uint id = companies.length - 1;

        emit NewCompany(id, _name);
    }

    function getCompanies() 
    external view 
    returns (Company[] memory) 
    {
        return companies;
    }

    function getCompanyMember(uint _companyId)
    external view
    returns (address[] memory)
    {
        return companyToMembers[_companyId];
    }

    function addMember(uint _companyId, address _user)
    public
    {
        companyToMembers[_companyId].push(_user);
        emit NewCompanyMember(_companyId, _user);
    }
}