// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

library Helpers {
    function _verify(address signer, bytes32 hash, bytes calldata signature) internal pure returns (bool) {
        return signer == ECDSA.recover(hash, signature);
    }

    function _hash(address account, uint256 amount, address contractAddress) internal pure returns (bytes32) {
        return ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(account, amount, contractAddress)));
    }
}
