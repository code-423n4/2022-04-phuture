// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.8.7;

import "./IIndexFactory.sol";

/// @title Tracked index factory interface
/// @notice Contains logic for tracked index creation
interface ITrackedIndexFactory is IIndexFactory {
    event TrackedIndexCreated(address index, address[] assets);

    /// @notice Create dynamic index with assets and their weights
    /// @param _assets Assets list for the index
    /// @param _nameDetails Name details data (name and symbol) to use for the created index
    /// @return index Created index address
    function createIndex(address[] calldata _assets, NameDetails calldata _nameDetails)
        external
        returns (address index);
}
