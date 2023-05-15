// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {BaseTest} from "../BaseTest.t.sol";
import {Token} from "../../src/fuzz/Token.sol";
import {console} from "forge-std/console.sol";

contract TokenTest is BaseTest {
    event Transfer(address indexed from, address indexed to, uint256 value);

    Token public token;

    function setUp() public override {
        super.setUp();

        vm.startPrank(owner);

        token = new Token("Test", "TST");

        token.mint(user1, 100);
    }

    function testNameAndSymbolSet() public {
        assertEq(token.name(), "Test");
        assertEq(token.symbol(), "TST");
    }

    /**
     * @dev expecting reverts.
     *  testCannot in combination with expectRevert
     *  if below expect message is not correct, the test will revert
     */
    function testCannotTransferWithoutBalance() public {
        vm.expectRevert("ERC20: transfer amount exceeds balance"); //if we change the string it will fail

        // executed by the owner (non-holder)
        // token.mint(owner, 100); // if we mint here, revert will not happen, so the test will fail
        token.transfer(user1, 1);
    }

    function testTransfer() public {
        uint256 initialUser1Balance = token.balanceOf(user1);
        uint256 initialUser2Balance = token.balanceOf(user2);
        uint256 transferBalance = 10;

        // First 3 arguments -> whether to assert indexed/noGasMetering
        // Last argument -> whether to expect the data
        vm.expectEmit(true, true, false, true);
        emit Transfer(user1, user2, transferBalance);

        assertEq(initialUser1Balance, 100);
        assertEq(initialUser2Balance, 0);

        changePrank(user1);
        token.transfer(user2, transferBalance);

        assertEq(token.balanceOf(user1), initialUser1Balance - transferBalance);
        assertEq(token.balanceOf(user2), initialUser2Balance + transferBalance);
    }

    //@fuzzing
    function testTransfer(uint256 amount) public {
        vm.assume(amount < 100);
        changePrank(user1); //has balanceOf 100

        token.transfer(user2, amount);
    }
}
