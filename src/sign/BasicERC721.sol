// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {Errors} from "../libraries/Errors.sol";
import {Helpers} from "../libraries/Helpers.sol";
import {Types} from "../types/Types.sol";
import {Signable} from "./Signable.sol";

contract BasicERC721 is ERC721, Signable {
    // solhint-disable-next-line var-name-mixedcase
    uint256 public immutable TOKEN_PRICE;
    address public usdcContract;
    mapping(uint256 => uint256) public tokenPrices;

    // Counter used for token number in minting
    uint256 private _nextTokenCount = 1;

    /**
     * @dev Constructor function that sets the `usdcContract` variable and the `TOKEN_PRICE` variable.
     * @param _usdcContract The address of the USDC contract.
     */
    constructor(address _usdcContract) ERC721("BasicERC721", "B721") {
        usdcContract = _usdcContract;
        TOKEN_PRICE = 1e18;
    }

    /**
     * @dev Mint a new token to the caller.
     * @param permitSig A `Types.PermitSig` struct containing the permit signature.
     */
    function mint(Types.PermitSig calldata permitSig) external {
        if (permitSig.value != TOKEN_PRICE) {
            revert Errors.InvalidPrice(permitSig.value);
        }

        _permit(permitSig);

        _safeMint(msg.sender, _nextTokenCount);
        ++_nextTokenCount;
    }

    /**
     * @dev Mint a specified number of tokens to the caller.
     * @param amount The number of tokens to mint.
     * @param maxAmount The maximum number of tokens that can be minted with this signature.
     * @param signature The signature to verify.
     */
    function privateMint(uint256 amount, uint256 maxAmount, bytes calldata signature) external {
        if (!Helpers._verify(signer(), Helpers._hash(msg.sender, maxAmount, address(this)), signature)) {
            revert Errors.InvalidSignature();
        }

        for (uint256 i; i < amount;) {
            _safeMint(msg.sender, _nextTokenCount);

            unchecked {
                ++_nextTokenCount;
                ++i;
            }
        }
    }

    /**
     * @dev Verify a permit signature and transfer USDC tokens from the permit owner to the contract.
     * @param permitSig A `Types.PermitSig` struct containing the permit signature.
     */
    function _permit(Types.PermitSig calldata permitSig) private {
        IERC20(usdcContract).permit(
            permitSig.owner, address(this), permitSig.value, permitSig.deadline, permitSig.v, permitSig.r, permitSig.s
        );
        IERC20(usdcContract).transferFrom(permitSig.owner, address(this), permitSig.value);
    }
}
