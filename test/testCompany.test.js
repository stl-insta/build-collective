const Company = artifacts.require("CompanyFactory");

contract("Company", (accounts) => {
    let company;

    before(async () => {
        company = await Company.deployed();
    });

    describe('creating a company', async () => {
        it('can create a company', async () => {
            const isCreated = await company.createCompany("SpaceX");

            const companies = await company.getCompanies();

            assert.equal(companies[0].name, "SpaceX");
            assert.isOk(isCreated);
        });
    })

});