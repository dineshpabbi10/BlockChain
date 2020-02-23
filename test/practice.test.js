const Practice = artifacts.require("practice");
require("chai").use(require("chai-as-promised")).should();

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

    describe("TestList 2",async()=>{
        let result , id;
        before(async()=>{
            result = await practice.createItem("T-Shirt",web3.utils.toWei('1',"Ether"),{from : seller});
            id = practice.itemId();
        });

        it("Item Created Successfully",async()=>{
            const event = result.logs[0].args;
            assert.equal(event.id.toNumber(),1);
            assert.equal(event.itemName,"T-Shirt");
            assert.equal(event.owner,seller);
            assert.equal(event.isSold,false);
            assert.equal(event.price,web3.utils.toWei('1',"Ether"));
        });
    });
});