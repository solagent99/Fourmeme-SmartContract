// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title Fork starter token
/// @dev simple ERC20 with optional transfer fee, pause and rescue
contract Token is ERC20, Ownable, Pausable {
    uint16 public transferFeeBasis; // in bps (100 = 1%)
    address public feeReceiver;
    uint256 public immutable INITIAL_SUPPLY;

    event TransferFeeUpdated(uint16 oldFee, uint16 newFee);
    event FeeReceiverUpdated(address old, address new_);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_,
        address feeReceiver_
    ) ERC20(name_, symbol_) {
        INITIAL_SUPPLY = initialSupply_;
        _mint(msg.sender, initialSupply_);
        feeReceiver = feeReceiver_;
    }

    function setTransferFeeBasis(uint16 bps) external onlyOwner {
        require(bps <= 1000, "max 10%");
        emit TransferFeeUpdated(transferFeeBasis, bps);
        transferFeeBasis = bps;
    }

    function setFeeReceiver(address r) external onlyOwner {
        require(r != address(0), "zero addr");
        emit FeeReceiverUpdated(feeReceiver, r);
        feeReceiver = r;
    }

    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override whenNotPaused {
        if (transferFeeBasis > 0 && feeReceiver != address(0) && sender != feeReceiver && recipient != feeReceiver) {
            uint256 fee = (amount * uint256(transferFeeBasis)) / 10000;
            uint256 after = amount - fee;
            super._transfer(sender, feeReceiver, fee);
            super._transfer(sender, recipient, after);
        } else {
            super._transfer(sender, recipient, amount);
        }
    }

    // Rescue other ERC20 tokens accidentally sent here
    function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner {
        require(tokenAddress != address(this), "can't rescue self");
        IERC20(tokenAddress).transfer(owner(), amount);
    }
}
