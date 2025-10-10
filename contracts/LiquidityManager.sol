// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IRouter.sol";

/// @notice Skeleton for managing liquidity operations using a router.
/// @dev Intentionally minimal and emits events for off-chain monitoring. Fill in AMM math in a safe, auditable manner.
contract LiquidityManager is Ownable {
    IRouter public router;

    event LiquidityAdded(address indexed tokenA, address indexed tokenB, uint256 amountA, uint256 amountB, address to);
    event LiquidityRemoved(address indexed pair, uint256 liquidity, address to);

    constructor(address router_) {
        require(router_ != address(0), "zero router");
        router = IRouter(router_);
    }

    function setRouter(address router_) external onlyOwner {
        require(router_ != address(0), "zero router");
        router = IRouter(router_);
    }

    /// @notice Add liquidity via configured router
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        address to
    ) external onlyOwner returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        // Caller must have transferred tokens to this contract or the router must pull them.
        // Implementation depends on the target router; this skeleton delegates to router.
        (amountA, amountB, liquidity) = router.addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, to);
        emit LiquidityAdded(tokenA, tokenB, amountA, amountB, to);
    }

    // TODO: add safe wrappers for approvals, slippage checks and reserve validations.
}
