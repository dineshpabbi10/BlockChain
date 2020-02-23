pragma solidity >=0.4.21 <0.7.0;

contract Ethbay{
    string public hospitalName;
    address payable owner;
    uint public appointCount = 0;

    struct Appointment{
        uint id;
        string patientName;
        uint age;
        uint fee;
    }

    mapping(address => Appointment) public Appointments;
    mapping(address => bool) public isAppointed;
    mapping(address => bool) public isRefunded;

    event makeAppointment(
        uint id,
        string patientName,
        uint age,
        uint fee
    );

    event cancelAppointment(
        uint id,
        string patientName,
        uint age,
        uint fee
    );

    constructor() public{
        hospitalName = "EECE571G HOSPITAL";
        owner = msg.sender;
    }

    function bookAppointment(string memory patientName, uint age,uint fee) public payable{
        bool isBooked = isAppointed[msg.sender];
        require(isBooked == false,"You already have an appointment");
        require(bytes(patientName).length>0,"Patient Name cannot be empty");
        require(age>0,"Age should be greater than 0");
        require(fee>0,"Fee should be greater than 0");
        require(msg.value >= fee,"Value should be greater than fee");
        require(msg.sender != owner,"Owner cannot book appointment");
        isAppointed[msg.sender] = true;
        appointCount = appointCount + 1;
        Appointments[msg.sender] = Appointment(appointCount,patientName,age,fee);
        owner.transfer(msg.value); // Payment Made
        isRefunded[msg.sender] = false;
        emit makeAppointment(appointCount,patientName,age,fee);
    }

    function cancelTheAppointment() public{
        bool isBooked = isAppointed[msg.sender];
        require(isBooked == true,"You dont have any appointment");
        require(msg.sender != owner,"Owner cannot book appointment");
        Appointment memory data = Appointments[msg.sender];
        data.patientName = "";
        isAppointed[msg.sender] = false;
        // msg.sender.transfer(2);
        emit cancelAppointment(data.id,data.patientName,data.age,data.fee);

    }

    function refund(address payable customer) public payable{
        bool isBooked = isAppointed[customer];
        bool re = isRefunded[customer];
        Appointment memory data = Appointments[customer];
        require(isBooked == false,"You did not cancel appointment");
        require(re == false,"The Money Was already Refunded");
        require(msg.sender == owner,"Only Owner can refund the money for Cancelled Appointment");
        require(msg.value > data.fee,"The value should be greater than fee");
        isRefunded[customer] = true;
        customer.transfer(msg.value);
    }
}

// contract Ethbay {
//     string public storeName;
//     uint public totalNumber = 0;
    // struct Item {
    //     uint itemId;
    //     string itemName;
    //     uint itemPrice;
    //     address payable itemOwner;
    //     bool isItemSold;
    // }

//     mapping(uint => Item) public items;

//     event ItemReady(
//         uint itemId,
//         string itemName,
//         uint itemPrice,
//         address payable itemOwner,
//         bool isItemSold
//     );

//     event ItemSold(
//         uint itemId,
//         string itemName,
//         uint itemPrice,
//         address payable itemOwner,
//         bool isItemSold
//     );

//     constructor() public {
//         storeName = "EECE571 ETHBAY.COM";
//     }

//     function createItem(string memory _itemName, uint _itemPrice) public {
//         require(bytes(_itemName).length > 0, "Item's name is required!");
//         require(_itemPrice > 0, "Item's price is required!");
//         totalNumber++;
//         items[totalNumber] = Item(totalNumber, _itemName, _itemPrice, msg.sender, false);
//         emit ItemReady(totalNumber, _itemName, _itemPrice, msg.sender, false);
//     }

//     function buyItem(uint _itemId) public payable {
//         Item memory _item = items[_itemId];
//         address payable _seller = _item.itemOwner;
//         require(_item.itemId > 0 && _item.itemId <= totalNumber, "Item should be ready to sell!");
//         require(msg.value >= _item.itemPrice, "Payment should be enough!" );
//         require(!_item.isItemSold, "Item should not been sold yet!");
//         require(msg.sender != _seller, "Cannot buy himself/herself");

//         _item.itemOwner = msg.sender;
//         _item.isItemSold = true;
//         items[_itemId] = _item;
//         _seller.transfer(msg.value);
//         emit ItemSold(_item.itemId, _item.itemName, _item.itemPrice, msg.sender, true);
//     }

// }