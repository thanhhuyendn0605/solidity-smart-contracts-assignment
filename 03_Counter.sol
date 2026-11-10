
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint256 public count;

    event CountChanged(address indexed user, uint256 newCount);

    constructor() {
        count = 0;
    }

    function increment() public {
        count += 1;
        emit CountChanged(msg.sender, count);
    }

    function decrement() public {
        require(count > 0, "Counter cannot be negative");
        count -= 1;
        emit CountChanged(msg.sender, count);
    }

    function reset() public {
        count = 0;
        emit CountChanged(msg.sender, count);
    }
}
