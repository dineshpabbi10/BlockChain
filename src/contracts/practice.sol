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
        address payable owner;
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
        itemId++;
        items[itemId] = item(itemId,name,msg.sender,false,price);
        emit createItemEvent(itemId,name,msg.sender,false,price);
    }

    function buyItem(uint256 id) public payable{
        address payable buyer = msg.sender;
        item memory _item= items[id];
        require(id>0 && id < itemId,"Item not available");
        require(buyer.balance > _item.price && msg.value > _item.price,"Either Balance or value specified is less than item price");
        require(buyer != _item.owner,"Owner of item cannot be buyer himself");
        require(_item.isSold == false,"Item already sold");
        items[id].isSold = true;
        _item.owner.transfer(msg.value);
        items[id].owner = buyer;
        emit createItemEvent(items[id].id,items[id].itemName,items[id].owner,items[id].isSold,items[id].price);
    }
}