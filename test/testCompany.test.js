const Company = artifacts.require("CompanyFactory");

contract("Company", (accounts) => {
    let companyFactory;
    let owner = accounts[0];
    let user = accounts[1];

    before(async () => {
        companyFactory = await Company.deployed();
        await companyFactory.createCompany("SpaceX");
    });

    it('can create a companyFactory', async () => {
        const companies = await companyFactory.getCompanies();
        assert.equal(companies[0].name, "SpaceX");
    });

    it('User can add itself as a member to a companyFactory', async () => {
        await companyFactory.addMember(0, 0);
    })

});