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

    // test bid

    // test bid fail after end

    // test correct timestamp with skip and rewind

    // test roll to specific block number
}
