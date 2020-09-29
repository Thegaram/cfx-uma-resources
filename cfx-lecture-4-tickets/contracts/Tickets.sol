// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.7.1;

contract Tickets {
    address public owner;

    uint256 public num_tickets = 100;
    uint256 public price_drips = 10 * 1e18; // 10 CFX
    mapping (address => bool) public has_ticket;

    event Validated(address visitor);

    constructor() {
        owner = msg.sender;
    }

    // buy ticket
    function buy() public payable {
        // check that we still have tickets left
        require(num_tickets > 0, "TICKETS: no tickets left");

        // check if the buying price is correct
        require(msg.value == price_drips, "TICKETS: incorrect amount");

        // check that user has no ticket yet
        require(!has_ticket[msg.sender], "TICKETS: already has a ticket");

        // successful buy
        has_ticket[msg.sender] = true;
        num_tickets -= 1;
    }

    // validate ticket
    function validate(address visitor) public {
        require(msg.sender == owner, "TICKETS: unauthorized");
        require(has_ticket[visitor], "TICKETS: visitor has no ticket");

        has_ticket[visitor] = false;
        emit Validated(visitor);
    }

    // withdraw profit
    function withdraw() public {
        require(msg.sender == owner, "TICKETS: unauthorized");
        uint256 profit = address(this).balance;
        msg.sender.transfer(profit);
    }
}