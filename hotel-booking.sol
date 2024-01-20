//SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

contract Hotel{
    address public hotelOwner;    
    // declare the state variable - hotelOwner
    // make the address public
    uint roomCost = 2 ether;
    // the cost of a room

    mapping (address => uint) balancex;

    enum RoomStatus {
        Vacant,
        Occupied
    }
    RoomStatus public status;

    constructor() { 
        hotelOwner = msg.sender;  
        // the sender of the FIRST transaction is deemed as the HotelOwner      
    }

    event Occupy (address occupant, uint value);
    // create an event which will be emitted after every success transaction

    receive() external payable {
        require (status == RoomStatus.Vacant, "Room is Occupied. Contact Reception!");
        // ensure status is vacant    
        require (msg.value==roomCost, "Invalid Amount!");
         // ensure amount paid is equal to the roomCost ie. 2 ether    
        payable(hotelOwner).transfer (msg.value);
        // transfer the funds to the hotel owner
        status = RoomStatus.Occupied;
        // change the room status to OCCUPIED
        emit Occupy (msg.sender, msg.value);
        // emit the event - show the address of the customer and the amount sent
        balancex [hotelOwner] += msg.value;
        // update the balance of the hotel owner
    }

    function checkBalance() public view returns (uint) {
        require (msg.sender==hotelOwner, "You are not authorized to perform this action!");
        // this ensures that this function is exclusive to the Hotel Owner
        uint x=balancex[hotelOwner];
        return x;
        // asssigns the current balance to the variable 'x' and return it
    }

    function changeStatus() public {
        require (msg.sender==hotelOwner, "You are not authorized to perform this action!");
        // ensures that the hotel owner is the only one who can do this

        if (status == RoomStatus.Occupied) {
            status = RoomStatus.Vacant;
        }
        else {
            status = RoomStatus.Occupied;
        }
        // the hotel owner can change the status if a room IF and WHEN (s)he wants
    }
    
}