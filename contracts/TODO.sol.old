pragma solidity >=0.4.22 <0.9.0;

contract TODO {

    /* Mappings */

    mapping (uint => address) public companyToOwner;
    mapping (uint => address) public projectToOwner;
    mapping (uint => uint) public bountyToProject;
    mapping (uint => address) public bountyToHunter;
    mapping (uint => uint) public fixToBounty;

    /* Structs */

    struct Company {
        string name;
        address[] members;
    }

    struct Project {
        string name;
        string description;
        string url;
        uint balance;
        address[] contributors;
    }

    struct Bounty {
        string name;
        string description;
        uint reward;
        string status; // Fixed | In progress
    }

    struct Fix {
        address user;
        string proposition;
    }

    /* Functions */

    function _createCompany() public {}

    function _createProject() public {}

    function _createBounty() public {}

    function _createFix() public {
        
    }

    function _sponsorProject(uint _idProject, uint amount) public {

    }

    function _payContributor(
        uint _idProject,
        address _contributor,
        uint amount
    ) 
        public 
        onlyProjectOwner(
            _idProject
        ) 
        onlyContributors(
            _idProject
        ) {

    }

    function _proposeFixBounty(uint _idBounty, string memory proposition) public {
        // A user proposes a fix to a bounty
    }

    function _acceptFix(uint _fixId, uint _idProject) public onlyProjectOwner(_idProject) {
        // The bounty owner chose a _fixId
        // Pays the Fix.user
        // Changes status of Bounty to Fixed
    }

    // Fetch githup API to get status of a PR
    // No longer need to manage Fix on Bounty


}