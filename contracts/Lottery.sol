// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

// import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/evm-contracts/src/v0.6/VRFConsumerBase.sol";


contract LotteryContract {
    mapping(address => uint) public balances;
    address payable public owner;
    address payable public winner;
    address payable[] public players;

    enum LotteryStatus {Open, Closed}

    constructor(){
        owner = payable(msg.sender);
    }

    function closeLottery() public onlyOwner {
        require(players.length >= 3);
        winner = payable(players[random()]);
        winner.transfer(getContractBal());
        players = new address payable[](0);
    }


    function getContractBal() public view onlyOwner returns(uint){
        return address(this).balance;
    }

    receive() payable external {
        players.push(payable(msg.sender));
        balances[msg.sender] += msg.value;
    }

    fallback() payable external {
        // receive();
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function random() public view returns (uint) {
        // sha3 and now have been deprecated
        // convert hash to integer
        return uint(keccak256(abi.encodePacked(
            block.difficulty, 
            block.timestamp, 
            msg.sender))) % players.length;
    }
}