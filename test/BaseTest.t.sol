// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Utilities} from "./utils/Utilities.t.sol";

contract BaseTest is Test {
    Utilities internal utils;
    address payable[] internal users;

    address payable internal owner;
    address payable internal user1;
    address payable internal user2;

    function setUp() public virtual {
        utils = new Utilities();
        users = utils.createUsers(3);

        owner = users[0];
        user1 = users[1];
        user2 = users[2];
    }
}
