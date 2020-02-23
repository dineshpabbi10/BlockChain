const Practice = artifacts.require("practice");
require("chai").user(require("chai-as-promised")).should();

contract(Practice,async ([deployer,buyer,seller])=>{
    
    // <-------------- First Step get the deployed contract---------------->
    let practice;
    before(async()=>{
        practice = await Practice.deployed();
    });

    // <--------------- Making testcases ---------------------------------->
    describe("TestList 1 ",async()=>{

        it("Deployment successfull",async()=>{
            const address = practice.address;
            assert.notEqual(address,"0x0");
            assert.notEqual(address,"");
        });

        it("Store name and deployer is correct",async()=>{
            const name = await practice.storeName();
            const _deployer = await practice.deployer();
            assert.equal("Test Store",name);
            assert.equal(_deployer,deployer);
        });

    });
});