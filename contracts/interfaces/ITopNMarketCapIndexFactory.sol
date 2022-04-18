// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.8.7;

import "./IIndexFactory.sol";

/// @title Top N market capitalization index factory interface
/// @notice Contains logic for top N market capitalization index creation
interface ITopNMarketCapIndexFactory is IIndexFactory {
    event TopNMarketCapIndexCreated(address index, uint category, uint topN);

    /// @notice Sets market cap categories address
    /// @param _marketCapCategories Market cap categories address
    function setMarketCapCategories(address _marketCapCategories) external;

    /// @notice Sets maximum allowed number of assets to be included into index
    /// @param _topN Maximum allowed number of assets to be included into index
    function setMaxAllowedTopN(uint8 _topN) external;

    /// @notice Create dynamic index with provided params
    /// @param _category Market cap category index of type TopNMarketCapCategory to use
    /// @param _topN Number of asset to include into index
    /// @param _nameDetails Name details data (name and symbol) to use for the created index
    /// @return index Created index address
    function createIndex(
        uint _category,
        uint8 _topN,
        NameDetails calldata _nameDetails
    ) external returns (address index);

    /// @notice Market cap categories address
    /// @return Returns market cap categories address
    function marketCapCategories() external view returns (address);

    /// @notice Maximum allowed number of assets to be included into index
    /// @return Returns maximum allowed number of assets to be included into index
    function maxAllowedTopN() external view returns (uint8);
}
