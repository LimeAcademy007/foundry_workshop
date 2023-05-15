// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./BaseTest.t.sol";
import "../src/Counter.sol";

contract CounterTest is BaseTest {
    Counter public counter;

    event LogSetNumber(address indexed from, uint256 number);

    function setUp() public override {
        super.setUp();
        counter = new Counter();
        counter.setNumber(0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function _send(uint256 amount) private {
        (bool ok,) = address(counter).call{value: amount}("");
        require(ok, "send ETH failed!");
    }

    //testFail
    function testFailDecrement() public {
        counter.decrement();
    }

    //expectRevert with error
    function testDecrementUnderflow() public {
        vm.expectRevert(stdError.arithmeticError);
        counter.decrement();
    }

    //console.log
    function testLogSomething() public view {
        console.log("We are logging something from the contract");
    }

    //console.logInt
    function testLogInt() public view {
        int256 x = -1;
        console.logInt(x);
    }

    //assertTrue
    function testAssertTrue() public {
        assertTrue(counter.number() == 0);
    }

    //vm.prank
    function testFailNotOwner() public {
        vm.prank(user1);
        counter.setOwner(user1);
    }

    //expectRevert with require
    function testNotOwner() public {
        vm.prank(user1);
        vm.expectRevert(bytes("caller is not the owner")); // can be passed withouth bytes already
        counter.setOwner(user1);
    }

    //vm.startPrank & vm.stopPrank
    function testFailSetOwnerAgain() public {
        // msg.sender = address(this)
        counter.setOwner(user1);
        vm.startPrank(user1);

        // msg.sender = user1
        counter.setOwner(user1);
        counter.setOwner(user1);
        counter.setOwner(user1);
        vm.stopPrank();

        //msg.sender = address(this)
        counter.setOwner(user1);
    }

    //emit events
    function testEmitSetNumberEvent() public {
        // Tell foundry which data from the event to check:
        vm.expectEmit(true, true, true, true);

        // Emit the expected event
        emit LogSetNumber(address(this), 123);

        // Call the function that should emit the event
        counter.setNumber(123);
    }

    //test ETH Balance
    function testEthBalance() public view {
        console.log("ETH Balance", address(this).balance / 1e18);
    }

    //test send ETH with deal & hoax
    function testSendEth() public {
        // deal - set the balance of an address
        deal(user1, 100);
        assertEq(user1.balance, 100);

        // Note that after the second call of the deal, the balance is not 100 + 10, but just 10
        deal(user1, 10);
        assertEq(user1.balance, 10);

        // hoax - set the balance of an address and then call prank, so the call after that will be with the msg.sender that we've specified in the hoax function
        // Let's see the two variants (with deal and hoax)

        deal(user1, 123);
        _send(123); // send will be called from this contract (msg.sender will be this). We are not sending the value from user1 address.

        // To do it we need to do:
        deal(user1, 123);
        vm.prank(user1);
        _send(123);

        // hoax
        hoax(user1, 123);
        _send(123);
    }
}
