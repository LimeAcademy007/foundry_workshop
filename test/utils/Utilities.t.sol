// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";

contract Utilities is Test {
    bytes32 internal nextUser = keccak256(abi.encodePacked("user address"));
    address private currentPrank;

    function getNextUserAddress() external returns (address payable) {
        //bytes32 to address conversion
        address payable user = payable(address(uint160(uint256(nextUser))));
        nextUser = keccak256(abi.encodePacked(nextUser));
        return user;
    }

    /// @notice create users with 100 ether balance
    function createUsers(
        uint256 userNum
    ) external returns (address payable[] memory) {
        address payable[] memory users = new address payable[](userNum);
        for (uint256 i = 0; i < userNum; i++) {
            address payable user = this.getNextUserAddress();
            vm.deal(user, 100 ether);
            users[i] = user;
        }
        return users;
    }

    function convertUsersToUnpayable(
        address payable[] memory users
    ) external pure returns (address[] memory) {
        address[] memory unpayableUsers = new address[](users.length);
        for (uint256 i = 0; i < users.length; i++) {
            unpayableUsers[i] = address(users[i]);
        }
        return unpayableUsers;
    }

    /// @notice move block.number forward by a given number of blocks
    function mineBlocks(uint256 numBlocks) external {
        uint256 targetBlock = block.number + numBlocks;
        vm.roll(targetBlock);
    }

    function signMessage(
        uint256 privateKey,
        bytes32 hash
    ) external pure returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hash);
        return makeSignatureFromVRS(v, r, s);
    }

    // Useful if you have signature (for example from web2 JS call) string (135 in length) and want to convert it to bytes
    function bytesSignatureFromString(
        string memory s
    ) public pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length % 2 == 0);
        bytes memory r = new bytes(ss.length / 2 - 1);
        for (uint256 i = 0; i < (ss.length / 2 - 1); ++i) {
            uint256 sI = i + 1;
            r[i] = bytes1(
                fromHexChar(uint8(ss[2 * sI])) *
                    16 +
                    fromHexChar(uint8(ss[2 * sI + 1]))
            );
        }
        return r;
    }

    function makeSignatureFromVRS(
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public pure returns (bytes memory) {
        bytes memory sig = new bytes(65);
        assembly {
            mstore(add(sig, 65), v)
            mstore(add(sig, 32), r)
            mstore(add(sig, 64), s)
        }
        return sig;
    }

    // Helper for bytesSignatureFromString
    function fromHexChar(uint8 c) private pure returns (uint8) {
        if (bytes1(c) >= bytes1("0") && bytes1(c) <= bytes1("9")) {
            return c - uint8(bytes1("0"));
        }
        if (bytes1(c) >= bytes1("a") && bytes1(c) <= bytes1("f")) {
            return 10 + c - uint8(bytes1("a"));
        }
        if (bytes1(c) >= bytes1("A") && bytes1(c) <= bytes1("F")) {
            return 10 + c - uint8(bytes1("A"));
        }
        revert("fail");
    }

    function epsilon(
        uint256 _a,
        uint256 _b,
        uint256 _epsilon
    ) public pure returns (bool) {
        if (_a > _b) {
            return _a - _b <= _epsilon;
        } else {
            return _b - _a <= _epsilon;
        }
    }

    function assertSemiEq(uint256 a, uint256 b) external {
        uint256 epsilonVal = 50;
        assertEq(epsilon(a, b, epsilonVal), true);
    }
}
