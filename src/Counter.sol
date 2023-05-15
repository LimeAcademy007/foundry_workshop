// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;
    address payable public owner;

    event LogSetNumber(address indexed from, uint256 number);
    event LogDeposit(address from, uint256 amount);

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit LogDeposit(msg.sender, msg.value);
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
        emit LogSetNumber(msg.sender, newNumber);
    }

    function getName() public pure returns (string memory) {
        return "Counter";
    }

    function increment() public {
        // solhint-disable-next-line no-console
        number++;
    }

    function decrement() public {
        number--;
    }

    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "caller is not the owner");
        payable(msg.sender).transfer(_amount);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "caller is not the owner");
        owner = payable(_owner);
    }
}
