// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.8.7;

/// @title Top N market capitalization categories interface
/// @notice Interface describing logic for top market capitalization categories management
interface ITopNMarketCapCategories {
    struct AssetCapitalization {
        uint position;
        uint capitalizationInBase;
    }

    struct DiffDetails {
        uint snapshotId;
        uint totalCapitalizationInBase;
        uint assetCount;
        DiffAsset[] assets;
    }

    struct DiffAsset {
        address asset;
        bool isRemoved;
        uint capitalizationInBase;
    }

    struct _AssetCapitalization {
        address asset;
        uint capitalizationInBase;
    }

    struct UpdateCategoryParams {
        address asset;
        bool isRemoved;
    }

    event UpdateAsset(uint categoryId, address asset, bool isRemoved);
    event SetCategoryEnabled(uint categoryId, bool enabled);
    event RefreshMarketCap(uint categoryId, uint snapshot, address asset, uint capitalization, uint position);

    /// @notice Initialize categories with the given parameters
    /// @param _registry Index registry address
    /// @param _refreshTimeout Minimum time interval between category refreshes
    /// @param _minAssetCount Minimum asset count per category
    function initialize(
        address _registry,
        uint64 _refreshTimeout,
        uint32 _minAssetCount
    ) external;

    /// @notice Sets minimum time interval between category refreshes
    /// @param _refreshTimeout Minimum time interval between category refreshes
    function setRefreshTimeout(uint64 _refreshTimeout) external;

    /// @notice Sets minimum asset count per category
    /// @param _minAssetCount Minimum asset count per category
    function setMinAssetCount(uint32 _minAssetCount) external;

    /// @notice Enables or disables given category
    /// @param _categoryId Category id to update
    /// @param _enabled Enable / disable flag
    function setCategoryEnabled(uint _categoryId, bool _enabled) external;

    /// @notice Updates given category with UpdateCategoryParams information
    /// @param _categoryId Category id to update
    /// @param _changes UpdateCategoryParams object array containing assets list and their enabled/disabled status
    function updateCategory(uint _categoryId, UpdateCategoryParams[] calldata _changes) external;

    /// @notice A 'poke' function for market capitalization refresh given enough time has passed
    /// @param _categoryId Category id to update
    /// @param _assets Assets list to be updated
    /// @param _assetPositions Assets corresponding market positions
    function refreshMarketCaps(
        uint _categoryId,
        address[] calldata _assets,
        uint[] calldata _assetPositions
    ) external;

    /// @notice Minimum time interval between category refreshes
    /// @return Returns minimum time interval between category refreshes
    function refreshTimeout() external view returns (uint64);

    /// @notice Minimum asset count per category
    /// @return Returns minimum asset count per category
    function minAssetCount() external view returns (uint32);

    /// @notice Compare asset changes (diff) between provided snapshots within given category
    /// @param _categoryId Category id to check
    /// @param _lastSnapshotId Snapshot id to compare with the latest snapshot
    /// @param _topN Assets amount to compare
    /// @return diff Assets diff object of type DiffDetails
    function assetDiff(
        uint _categoryId,
        uint _lastSnapshotId,
        uint _topN
    ) external view returns (DiffDetails memory diff);

    /// @notice Returns list of category assets and their capitalizations
    /// @param _categoryId Category id to get assets from
    /// @param _offset Number of assets to skip from inclusion in result
    /// @param _count Number of assets to include in result
    /// @return assets List of assets
    /// @return capitalizations List of asset corresponding capitalizations
    /// @return totalCapitalization Total category assets capitalization
    function getCategoryAssets(
        uint _categoryId,
        uint _offset,
        uint _count
    )
        external
        view
        returns (
            address[] memory assets,
            uint[] memory capitalizations,
            uint totalCapitalization
        );

    /// @notice Returns list of category assets and their capitalizations for the given snapshot
    /// @param _categoryId Category id to get assets from
    /// @param _snapshotId Snapshot id to read from
    /// @param _offset Number of assets to skip from inclusion in result
    /// @param _count Number of assets to include in result
    /// @return assets List of assets for the given snapshot
    /// @return capitalizations List of asset corresponding capitalizations for the given snapshot
    /// @return totalCapitalization Total category assets capitalization for the given snapshot
    function getSnapshotAssets(
        uint _categoryId,
        uint _snapshotId,
        uint _offset,
        uint _count
    )
        external
        view
        returns (
            address[] memory assets,
            uint[] memory capitalizations,
            uint totalCapitalization
        );

    /// @notice Returns category information
    /// @param _categoryId Category id to get information for
    /// @return lastSyncTime Last category sync time
    /// @return enabled Flag indicating if category is enabled
    /// @return snapshot Current category snapshot
    function category(uint _categoryId)
        external
        view
        returns (
            uint lastSyncTime,
            bool enabled,
            uint snapshot
        );
}
