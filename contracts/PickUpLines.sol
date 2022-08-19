// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "hardhat/console.sol";
contract PickUpLines {
    event NewPickUpLine(address indexed from, uint256 timestamp, string line); 
    event UpdateLikes(address indexed from, uint256 timestamp, address indexed writer,uint256 likes); 
    event TransferMoney(address indexed from, uint256 timestamp, address indexed writer);

    uint256 private seed; 
    address[] winners;
    mapping(address => bool) hasWrote;
    mapping(address=>bool) hasLiked;
    mapping(address=>uint256)writerLikes;
    struct PickUpLine {  
        address writer;
        string line; 
        uint256 timestamp; 
    }
    PickUpLine[] pickuplines;

    address[] likedPeople;

    constructor() payable {
        console.log("I am the Cheesy PickUp Lines' smart contract!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function newLine(string memory _line) public {
        if (hasWrote[msg.sender]) {
            revert(
                "It seems you've posted a line already. We don't do repeats when it comes to pick up lines!"
            );
        } 
        pickuplines.push(PickUpLine(msg.sender, _line,block.timestamp));
        hasWrote[msg.sender] = true;
        writerLikes[msg.sender] = 0;
        emit NewPickUpLine(msg.sender, block.timestamp, _line); 
    }

     function addLikes(address pickUpLineWriter) public
     {
      if (hasLiked[msg.sender]) {
            revert(
                "It seems you've already Casted your vote.!"
            );
        }
         writerLikes[pickUpLineWriter] +=1 ; 
        uint256 likes = writerLikes[pickUpLineWriter];
        hasLiked[msg.sender]=true;
        emit UpdateLikes(msg.sender,block.timestamp,pickUpLineWriter, likes);
     } 

     function checkIfUserpickedUp() public view returns (bool) 
     {
        bool hasUserWrote =false;
       if (hasWrote[msg.sender]) {
           hasUserWrote = true;
        }
        return hasUserWrote;
     } 

     function checkIfUserLiked() public view returns (bool)
     {
            bool hasUerLiked =false;
         if (hasLiked[msg.sender]) {
           hasUerLiked = true;
        }
        return hasUerLiked;
     }

    function getAllLines() public view returns (PickUpLine[] memory) { 
        return pickuplines;
    }

    function getLinesLike() public view returns (address[] memory,uint256[] memory)
    {
        uint256[] memory totalLikes =new uint256[](pickuplines.length);
                address[] memory writer =new address[](pickuplines.length);
        for(uint i=0;i<pickuplines.length;i++)
        {
            writer[i] = pickuplines[i].writer;
           totalLikes[i] = writerLikes[pickuplines[i].writer];
        }
        return(writer,totalLikes);
    }

    function transferPrize(address winner) public
    {
       address payable winnerAddress = payable(winner);
       winnerAddress.transfer(1 ether);
       emit TransferMoney(msg.sender,block.timestamp,winner);
    }  
}
