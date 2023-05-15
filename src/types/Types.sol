// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

library Types {
    struct PermitSig {
        address owner;
        uint256 value;
        uint256 deadline;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }
}
