pragma solidity >0.4.21 < 0.7.0;

contract practice{
    string public storeName;
    uint256 public itemId = 0;
    address payable deployer;

    constructor() public{
        storeName = "Test Store";
        deployer = msg.sender;
    }

    struct item{
        uint256 id;
        string itemName;
        address owner;
        bool isSold;
        uint price;
    }

    mapping(uint256 => item) public items;

    event createItemEvent(
        uint256 id,
        string itemName,
        address owner,
        bool isSold,
        uint price
    );

    event buyItemEvent(
        uint256 id,
        string itemName,
        address owner,
        bool isSold,
        uint price
    );
    
    function createItem(string memory name,uint256 price) public{
        require(bytes(name).length > 0,"Item name Cannot be Empty");
        require(price > 0,"Price should be greater than 0");

  