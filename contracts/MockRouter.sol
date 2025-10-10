// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Simple mock router implementing the minimal `addLiquidity` used in tests.
/// @dev Deterministic and gas-cheap: it does NOT attempt to transfer tokens. It simply returns the requested amounts
///      and a deterministic \"liquidity\" value (amountA + amountB) for assertions.
contract MockRouter {
    event MockAddLiquidity(address indexed tokenA, address indexed tokenB, uint256 amountA, uint256 amountB, address to);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        address to
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        // In a real router this would transfer/require approvals and mint LP tokens.
        // For tests, simply return the desired amounts and a deterministic liquidity figure.
        amountA = amountADesired;
        amountB = amountBDesired;
        liquidity = amountADesired + amountBDesired; // simple deterministic marker

        emit MockAddLiquidity(tokenA, tokenB, amountA, amountB, to);
    }
}
