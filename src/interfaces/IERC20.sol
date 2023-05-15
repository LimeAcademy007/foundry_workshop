// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

interface IERC20 {
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external;

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function nonces(address owner) external view returns (uint256);
}
