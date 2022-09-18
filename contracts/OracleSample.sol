// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

contract OptionsContract {
    address payable public owner;
    address payable public player;
    uint public endTime;
    bool public started;
    bool public isAgainstBet;
    
    address payable public winner;
    
    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    /// @notice Setup the bet for over 10 degrees
    function betOver10Degree() public payable {
        setBet(true);
    }
    
    function betUnder10Degree() public payable {
        setBet(false);
    }
    
    function setBet(bool _isAgainstBet) private {
        require(!started);
        started = true;
        player = payable(msg.sender);
        endTime = block.timestamp + 10 seconds;
        isAgainstBet = _isAgainstBet;
    }

    function determineWinner(uint _temp) public onlyOwner {
        require(block.timestamp >= endTime);
        //here we need to find a way to retrieve the weather at endTime. How can we? We can't escape the sandbox...
        
        // require(msg.sender ==  0xa6c5A11f394b357256bE02d0A6A344F194100ed1);
        if(_temp > 10) {
            if(isAgainstBet) {
                winner = player;
            } else {
                winner = owner;
            }
        } else {
            if(isAgainstBet) {
                winner = owner;
            } else {
                winner = player;
            }
        }
        
    }
    
    function withdraw() public {
        require(winner != address(0x0));  
        winner.transfer(address(this).balance);
    }    
}

