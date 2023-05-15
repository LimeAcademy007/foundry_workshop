// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import {IERC20} from "../../src/interfaces/IERC20.sol";
import {EIP712} from "../../src/libraries/EIP712.sol";
import {console} from "forge-std/console.sol";

contract TestUSDC is IERC20 {
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    bytes32 public DOMAIN_SEPARATOR;

    mapping(address => mapping(address => uint256)) internal allowed;
    mapping(address => uint256) internal balances;
    mapping(address => bool) internal blacklisted;

    function blacklist(address _account) external {
        blacklisted[_account] = true;
    }

    function isBlacklisted(address _account) external view returns (bool) {
        return blacklisted[_account];
    }

    modifier notBlacklisted(address _account) {
        require(!blacklisted[_account], "Blacklistable: account is blacklisted");
        _;
    }

    constructor() {
        DOMAIN_SEPARATOR = EIP712.makeDomainSeparator("USDC", "2");
    }

    mapping(address => uint256) private _permitNonces;

    function nonces(address owner) external view returns (uint256) {
        return _permitNonces[owner];
    }

    function mint(address to, uint256 amount) external {
        balances[to] += amount;
    }

    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external
    {
        require(deadline >= block.timestamp, "FiatTokenV2: permit is expired");

        bytes memory data = abi.encode(PERMIT_TYPEHASH, owner, spender, value, _permitNonces[owner]++, deadline);
        require(EIP712.recover(DOMAIN_SEPARATOR, v, r, s, data) == owner, "EIP2612: invalid signature");

        _approve(owner, spender, value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        allowed[owner][spender] = value;
    }

    function transferFrom(address from, address to, uint256 value) external notBlacklisted(to) returns (bool) {
        require(value <= allowed[from][msg.sender], "ERC20: transfer amount exceeds allowance");
        _transfer(from, to, value);
        allowed[from][msg.sender] = allowed[from][msg.sender] - value;
        return true;
    }

    function transfer(address to, uint256 value) external override notBlacklisted(to) returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value <= balances[from], "ERC20: transfer amount exceeds balance");

        balances[from] = balances[from] - value;
        balances[to] = balances[to] + value;
    }

    function balanceOf(address account) external view returns (uint256) {
        console.log("console.log in the contract", account, balances[account]);
        return balances[account];
    }

    function version() external pure returns (string memory) {
        return "2";
    }
}
