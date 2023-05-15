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
        (bool ok, ) = address(counter).call{value: amount}("");
        require(ok, "send ETH failed!");
    }

    //testFail

    //expectRevert with error

    //console.log

    //console.logInt

    //assertTrue

    //vm.prank

    //expectRevert with require

    //vm.startPrank & vm.stopPrank

    //emit events

    //test ETH Balance

    //test send ETH with deal & hoax
}
