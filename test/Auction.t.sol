// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./BaseTest.t.sol";
import "../src/Auction.sol";

contract AuctionTest is BaseTest {
    Auction public auction;
    uint256 public startAt;

    function setUp() public override {
        super.setUp();
        auction = new Auction();
        startAt = block.timestamp;
    }

    // test bid fail before start
    function testBidFailBeforeStart() public {
        vm.expectRevert("cannot bid the auction");
        auction.bid();
    }

    // test bid
    function testBid() public {
        vm.warp(startAt + 1 days);
        auction.bid();
    }

    // test bid fail after end
    function testBidFailAfterEnd() public {
        vm.expectRevert("cannot bid the auction");
        vm.warp(startAt + 2 days);
        auction.bid();
    }

    // test correct timestamp with skip and rewind
    function testCorrectTimestamp() public {
        uint256 t = block.timestamp;

        // skip -> increment the timestamp
        skip(100);
        assertEq(block.timestamp, t + 100);

        // rewind -> decrement the timestamp
        rewind(20);
        assertEq(block.timestamp, t + 100 - 20);
    }

    // test roll to specific block number
    function testBlockNumber() public {
        // vm.roll - set the block number
        vm.roll(999);
        assertEq(block.number, 999);
    }
}
