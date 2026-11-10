
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Greeting {
    string private greeting;

    event GreetingChanged(
        address indexed changedBy,
        string newGreeting
    );

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function setGreeting(string memory _newGreeting) public {
        greeting = _newGreeting;
        emit GreetingChanged(msg.sender, _newGreeting);
    }

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}
