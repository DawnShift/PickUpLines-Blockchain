// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "hardhat/console.sol";
contract PickUpLines {
    event NewPickUpLine(address indexed from, uint256 timestamp, string line); 
    event UpdateLikes(address indexed from, uint256 timestamp, address indexed writer);
    uint256 private seed;
    uint256 totalLines;
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
        //Adding a new Pickup Line to our blockchain.
        totalLines += 1;
        pickuplines.push(PickUpLine(msg.sender, _line,block.timestamp));
        hasWrote[msg.sender] = true;
        writerLikes[msg.sender] = 0;
        emit NewPickUpLine(msg.sender, block.timestamp, _line);

        // //Reward 10% of sender with 0.0001 ether.
        // seed = (block.difficulty + block.timestamp + seed) % 100;
        // if (seed <= 10) {
        //     winners.push(msg.sender);
        //     uint256 prizeAmount = 0.0001 ether;
        //     require(
        //         prizeAmount <= address(this).balance,
        //         "The contract has insufficient ETH balance."
        //     );
        //     (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        //     require(success, "Failed to withdraw ETH from the contract");
        // }
    }

     function addLikes(address pickUpLineWriter) public
     {
      if (hasLiked[msg.sender]) {
            revert(
                "It seems you've already Casted your vote.!"
            );
        }
         writerLikes[pickUpLineWriter] +=1 ; 
        emit UpdateLikes(msg.sender,block.timestamp,pickUpLineWriter);
     } 

    function getAllLines() public view returns (PickUpLine[] memory) {
        return pickuplines;
    }

    function getTotalLines() public view returns (uint256) {
        console.log("We have %s total PickUpLines.", totalLines);
        return totalLines;
    }

    function getTheWinner() private view returns (address[] memory) {
        return winners;
    }
}
