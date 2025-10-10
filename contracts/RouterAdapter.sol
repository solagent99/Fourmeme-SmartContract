// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Minimal subset of Pancake/UniswapV2 router functions used by LiquidityManager
interface IPancakeRouterLike {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        address to
    ) external returns (uint amountA, uint amountB, uint liquidity);

    // If you also need ETH pairs later:
    // function addLiquidityETH(
    //     address token,
    //     uint amountTokenDesired,
    //     uint amountTokenMin,
    //     uint amountETHMin,
    //     address to,
    //     uint deadline
    // ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

/// @title RouterAdapter
/// @notice Thin adapter that implements the minimal IRouter used by LiquidityManager and forwards to a Pancake-like router.
/// @dev This lets you configure the real Pancake router address when you migrate.
contract RouterAdapter {
    address public pancakeRouter;

    event RouterUpdated(address oldRouter, address newRouter);

    constructor(address _pancakeRouter) {
        require(_pancakeRouter != address(0), "zero router");
        pancakeRouter = _pancakeRouter;
    }

    function setRouter(address _pancakeRouter) external {
        require(_pancakeRouter != address(0), "zero router");
        address old = pancakeRouter;
        pancakeRouter = _pancakeRouter;
        emit RouterUpdated(old, _pancakeRouter);
    }

    /// @notice Forward addLiquidity call to underlying Pancake-like router
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        address to
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        (amountA, amountB, liquidity) = IPancakeRouterLike(pancakeRouter).addLiquidity(
            tokenA,
            tokenB,
            amountADesired,
            amountBDesired,
            to
        );
    }
}
