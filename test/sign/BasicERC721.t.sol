// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {BaseTest} from "../BaseTest.t.sol";
import {BasicERC721} from "../../src/sign/BasicERC721.sol";
import {TestUSDC} from "../utils/TestUSDC.sol";
import {Types} from "../../src/types/Types.sol";
import {SigUtils} from "../utils/SigUtils.sol";
import {Errors} from "../../src/libraries/Errors.sol";
import {Helpers} from "../../src/libraries/Helpers.sol";
import {console} from "forge-std/console.sol";

contract BasicERC721Test is BaseTest {
    BasicERC721 public erc721;
    TestUSDC public usdc;
    SigUtils public sigUtils;

    uint256 price;

    function setUp() public override {
        super.setUp();

        vm.startPrank(owner);

        usdc = new TestUSDC();
        sigUtils = new SigUtils(usdc.DOMAIN_SEPARATOR());
        erc721 = new BasicERC721(address(usdc));
        price = erc721.TOKEN_PRICE();
    }

    function testMint() public {
        uint256 deadline = block.timestamp + 30 minutes;

        changePrank(user1);

        usdc.mint(user1, price);

        assertEq(erc721.balanceOf(user1), 0);

        Types.PermitSig memory permitSig =
            _permitSig(user1, address(erc721), price, usdc.nonces(user1), deadline, user1Pk);

        erc721.mint(permitSig);
        assertEq(usdc.balanceOf(address(erc721)), price);
        assertEq(erc721.balanceOf(user1), 1);
    }

    function testMint_InvalidDeadline() public {
        uint256 deadline = block.timestamp + 30 minutes;

        usdc.mint(owner, price);

        assertEq(erc721.balanceOf(owner), 0);

        Types.PermitSig memory permitSig =
            _permitSig(owner, address(erc721), price, usdc.nonces(owner), deadline, ownerPk);

        vm.warp(block.timestamp + 3 hours);

        vm.expectRevert("FiatTokenV2: permit is expired");
        erc721.mint(permitSig);
    }

    function testMint_InvalidPrice() public {
        uint256 deadline = block.timestamp + 30 minutes;

        uint256 invalidPrice = price * 2;

        usdc.mint(owner, invalidPrice);

        assertEq(erc721.balanceOf(owner), 0);

        Types.PermitSig memory permitSig =
            _permitSig(owner, address(erc721), invalidPrice, usdc.nonces(owner), deadline, ownerPk);

        vm.expectRevert(abi.encodeWithSelector(Errors.InvalidPrice.selector, invalidPrice));
        erc721.mint(permitSig);
    }

    function testPrivateMint() public {
        uint256 allowed = 2;
        bytes memory userSignature = utils.signMessage(ownerPk, Helpers._hash(user1, allowed, address(erc721)));

        changePrank(user1);

        assertEq(erc721.balanceOf(user1), 0);
        erc721.privateMint(2, allowed, userSignature);

        assertEq(erc721.balanceOf(user1), 2);
    }

    function testPrivateMint_InvalidSignature() public {
        uint256 allowed = 2;
        bytes memory userSignature = utils.signMessage(
            user1Pk, //force failure
            Helpers._hash(user1, allowed, address(erc721))
        );

        changePrank(user1);

        vm.expectRevert(Errors.InvalidSignature.selector);
        erc721.privateMint(2, allowed, userSignature);
    }

    function _permitSig(
        address owner_,
        address spender,
        uint256 value,
        uint256 nonce,
        uint256 deadline,
        uint256 privateKey
    ) private view returns (Types.PermitSig memory permitSig) {
        SigUtils.Permit memory permit =
            SigUtils.Permit({owner: owner_, spender: spender, value: value, nonce: nonce, deadline: deadline});
        bytes32 digest = sigUtils.getTypedDataHash(permit);
        uint8 v;
        bytes32 r;
        bytes32 s;
        (v, r, s) = vm.sign(privateKey, digest);

        permitSig = Types.PermitSig({v: v, r: r, s: s, owner: owner_, value: value, deadline: deadline});
    }
}
