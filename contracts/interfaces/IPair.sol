// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPair {
    function getReserves() external view returns (uint256 reserve0, uint256 reserve1);
    function token0() external view returns (address);
    function token1() external view returns (address);
}
