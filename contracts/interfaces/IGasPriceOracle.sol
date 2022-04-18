// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.8.7;

/// @title Gas price oracle interface
/// @notice Describes methods to calculate gas fee
interface IGasPriceOracle {
    /// @notice Gas fee for reweight
    /// @return Returns gas fee for reweight
    function getFastGasInWei() external view returns (uint);
}
