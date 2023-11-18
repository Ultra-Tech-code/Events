// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.17;



contract Register {

    //Nb: string returns [object object] if indexed but returns the right value when not indexed so i won't be indexing the string events
    event Registered(address indexed _address, string _name, uint indexed _time);
    event Updated(address indexed _address, string _name, uint indexed _time);
    event Viewed(address indexed _address, string _name);

    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "NOT OWNER!!");
        _;
    }

    mapping(address => string) registered;
    mapping(string => bool) nameTaken;
    mapping(address => bool) addressTaken;

    function registerName(string memory name, address nameAddress) external onlyOwner{
        require(bytes(name).length > 0, "Name cannot be empty");
        require(nameAddress != address(0), "Zero Address");
        require(nameTaken[name] == false && addressTaken[nameAddress] == false, "Taken!!");
        registered[nameAddress] = name;

        nameTaken[name] = true;
        addressTaken[nameAddress] = true;

        emit Registered(nameAddress, name, block.timestamp);

    }
    
    function updateName(string memory newName, address nameAddress) external onlyOwner {
        require(bytes(newName).length > 0, "Name cannot be empty");
        require(addressTaken[nameAddress], "Address have no name, Register!!" );
        string memory initialName = registered[nameAddress];
        nameTaken[initialName] = false;
        nameTaken[newName] = true;
        registered[nameAddress] = newName;

        emit Updated(nameAddress, newName, block.timestamp);

    }

    function viewName(address nameAddress) public onlyOwner{
        require(addressTaken[nameAddress], "Address have no name, Register!!" );

        emit Viewed(nameAddress, registered[nameAddress]);
    }
}