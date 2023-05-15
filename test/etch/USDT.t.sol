// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {BaseTest} from "../BaseTest.t.sol";
import {console} from "forge-std/console.sol";
import {TestUSDC} from "../utils/TestUSDC.sol";

contract USDTTest is BaseTest {
    address constant USDT_ADDRESS = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    TestUSDC stableCoin;

    function setUp() public override {
        super.setUp();
        string memory provider = vm.envString("MAINNET_RPC_URL");
        uint256 blockNumber = 17252049;

        vm.createSelectFork(provider, blockNumber);

        stableCoin = new TestUSDC();
        vm.etch(USDT_ADDRESS, address(stableCoin).code);
    }

    function testBalanceOfOnMainnetVsLocal() public view {
        address someWhale = 0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503;

        uint256 balanceUSDT = TestUSDC(USDT_ADDRESS).balanceOf(someWhale); //mainnet
        uint256 balanceUSDTLocal = stableCoin.balanceOf(someWhale); // local

        console.log("balance: %s", balanceUSDT);
        console.log("balanceUSDTLocal: %s", balanceUSDTLocal);
    }
}
