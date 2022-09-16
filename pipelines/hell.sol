pragma solidity ^0.8.0;
contract Timelock {
    // amount of ether you deposited is saved in balances
    mapping(address => uint) public balances;
    // when you can withdraw is saved in lockTime
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        //update balance
        balances[msg.sender] +=msg.value;
        //updates locktime 1 week from now
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }   

    function withdraw() public {
        // check that the sender has ether deposited in this contract in the mapping and the balance is >0
        require(balances[msg.sender] > 0, "insufficient funds");
        // check that the now time is > the time saved in the lock time mapping
        require(block.timestamp > lockTime[msg.sender], "lock time has not expired");
        // update the balance
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;       
        // send the ether back to the sender
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ether");
    }
}