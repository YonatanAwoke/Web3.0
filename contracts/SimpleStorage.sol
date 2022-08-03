// SPDX-Lincense-Identifier:MIT

pragma solidity ^0.6.0;

//contract 
contract SimpleStorage{
    uint256 public favoriteNumber;
    bool favoriteBool;
    
    // structures are like classes that hold variables
    struct People {
        uint256 favoriteNumber;
        string name;
        
    }
    //arrays can hold different values
    People[] public people;
    mapping(string => uint256)public nameToFavoriteNumber;

    //People public person = People({favoriteNumber:2, name:"yonatan"});
    
    //functions are created to be executed for a certain action
    function store(uint256 _favoriteNumber)public{
        favoriteNumber=_favoriteNumber;
    }
    function retrieve ()public view returns(uint256){
        return favoriteNumber;
    }
    function addPerson(string memory _name,uint256 _favoriteNumber)public{
        people.push(People({favoriteNumber:_favoriteNumber,name:_name}));
        nameToFavoriteNumber[_name]=_favoriteNumber;
    }
} 