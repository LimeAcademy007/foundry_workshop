// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Contract that manages the signer/owner roles
abstract contract Signable is Ownable {
    error NewSignerCantBeZero();

    address private _signer;

    constructor() {
        _signer = msg.sender;
    }

    function signer() public view returns (address) {
        return _signer;
    }

    /// @notice This method allow the owner change the signer role
    /// @dev At first, the signer role and the owner role is associated to the same address
    /// @param newSigner The address of the new signer
    function transferSigner(address newSigner) external onlyOwner {
        if (newSigner == address(0)) revert NewSignerCantBeZero();

        _signer = newSigner;
    }
}
