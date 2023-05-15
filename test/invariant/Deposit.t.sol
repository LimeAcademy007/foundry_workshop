// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {BaseTest} from "../BaseTest.t.sol";
import {Deposit} from "../../src/invariant/Deposit.sol";
import {console} from "forge-std/console.sol";

contract DepositTest is BaseTest {
    Deposit deposit;

    function setUp() public override {
        super.setUp();

        //1. fail_on_revert = false
        //2. fail_on_revert = true
        //3. fail_on_revert = true && custom targetSenders (funded accounts)
        //4. fail_on_revert = true && //excludeContract
        //5. fail_on_revert = false & changeBalance

        //target contracts. All contracts deployed in the setup will be called over the course of a given invariant test
        deposit = new Deposit();

        // The invariant test fuzzer picks values for msg.sender at random when performing fuzz campaigns to simulate multiple actors in a system by default. If desired, the set of senders can be customized in the setUp function
        // targetSender(owner);
        // targetSender(user1);
        // targetSender(user2);

        excludeContract(address(utils));
        // targetContract(address(deposit)); // in our scenarios excludeContract(address(utils)); || targetContract(address(deposit)) will achieve the same result
    }

    function invariant_alwaysWithdrawable() external payable {
        deposit.deposit{value: 1 ether}();
        uint256 balanceBefore = deposit.balance(address(this));
        console.log("[console-1] before: %s", balanceBefore);

        assertEq(balanceBefore, 1 ether);
        deposit.withdraw();
        uint256 balanceAfter = deposit.balance(address(this));

        assertGt(balanceBefore, balanceAfter);
    }

    receive() external payable {}
}
