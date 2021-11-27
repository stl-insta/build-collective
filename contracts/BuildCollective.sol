pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
    struct User {
        string username;
        uint256 balance;
        bool registered;
    }

    address[] public listUser; 
    mapping(address => User) public users;

    event UserSignedUp(address indexed userAddress, User indexed user);

    function user(address userAddress) public view returns (User memory) {
        return users[userAddress];
    }

    function getAllUsers() external view returns (address[] memory) {
        return listUser;
    }

    function signUp(string memory username) public returns (User memory) {
        require(bytes(username).length > 0);
        users[msg.sender] = User(username, 0, true);
        emit UserSignedUp(msg.sender, users[msg.sender]);
        listUser.push(msg.sender);
        return users[msg.sender];
    }

    function addBalance(uint256 amount) public returns (bool) {
        require(users[msg.sender].registered);
        users[msg.sender].balance += amount;
        return true;
    }

    function withdrawBalance(uint256 _amount) public returns (bool) {
        require(users[msg.sender].registered);
        users[msg.sender].balance -= _amount;
        return true;
    }

    modifier hasSold(uint _amount) {
        require(user(msg.sender).balance >= _amount, "Not enough balance");
        _;
    }

    modifier isRegistered(address _user) {
        require(user(_user).registered, "User not registered");
        _;
    }

    /**
      Project
    */
    mapping(uint => address[]) public projectToContributors;

    Project[] public projects;

    event NewProject(uint projectId, string name, uint balance);
    event NewSponsor(uint projectId, uint amount);
    event NewContributor(uint contributorId, address user);

    struct Project {
        uint id;
        string name;
        uint balance;
        address owner;
        bool active;
    }

    function createProject(string memory _name)
    public
    {
        uint id = projects.length;
        projects.push(Project(id, _name, 0, msg.sender, true));
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

    /**
      Company
    */
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

    /**
       Bounty
    */
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
