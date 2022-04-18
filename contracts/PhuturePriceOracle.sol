// SPDX-License-Identifier: BUSL-1.1

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/access/IAccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import "./libraries/FixedPoint112.sol";

import "./interfaces/IPriceOracle.sol";
import "./interfaces/IIndexRegistry.sol";
import "./interfaces/IPhuturePriceOracle.sol";

import "./BaseFeeGasPriceOracle.sol";

/// @title Phuture price oracle
/// @notice Aggregates all price oracles and works with them through IPriceOracle interface
contract PhuturePriceOracle is IPhuturePriceOracle, BaseFeeGasPriceOracle {
    using ERC165CheckerUpgradeable for address;

    /// @notice Role allows configure asset related data/components
    bytes32 private constant ASSET_MANAGER_ROLE = keccak256("ASSET_MANAGER_ROLE");

    /// @notice Base asset address
    address public base;

    /// @notice Index registry address
    address public registry;

    /// @inheritdoc IPhuturePriceOracle
    mapping(address => address) public override priceOracleOf;

    /// @notice Decimals of base asset
    uint8 private baseDecimals;

    /// @notice Requires msg.sender to have `_role` role
    /// @param _role Required role
    modifier onlyRole(bytes32 _role) {
        require(IAccessControl(registry).hasRole(_role, msg.sender), "PhuturePriceOracle: FORBIDDEN");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    /// @inheritdoc IPhuturePriceOracle
    function initialize(address _registry, address _base) external override initializer {
        bytes4[] memory interfaceIds = new bytes4[](2);
        interfaceIds[0] = type(IAccessControl).interfaceId;
        interfaceIds[1] = type(IIndexRegistry).interfaceId;
        require(_registry.supportsAllInterfaces(interfaceIds), "PhuturePriceOracle: INTERFACE");
        require(_base != address(0), "PhuturePriceOracle: ZERO");

        __BaseFeeGasPriceOracle_init();

        base = _base;
        baseDecimals = IERC20Metadata(_base).decimals();
        registry = _registry;
    }

    /// @inheritdoc IPhuturePriceOracle
    function setOracleOf(address _asset, address _oracle) external override onlyRole(ASSET_MANAGER_ROLE) {
        require(_oracle.supportsInterface(type(IPriceOracle).interfaceId), "PhuturePriceOracle: INTERFACE");

        priceOracleOf[_asset] = _oracle;
    }

    /// @inheritdoc IPhuturePriceOracle
    function removeOracleOf(address _asset) external override onlyRole(ASSET_MANAGER_ROLE) {
        require(priceOracleOf[_asset] != address(0), "PhuturePriceOracle: UNSET");
        delete priceOracleOf[_asset];
    }

    /// @inheritdoc IPhuturePriceOracle
    function convertToIndex(uint _baseAmount, uint8 _indexDecimals) external view override returns (uint) {
        return (_baseAmount * 10**_indexDecimals) / 10**baseDecimals;
    }

    /// @inheritdoc IPhuturePriceOracle
    function containsOracleOf(address _asset) external view override returns (bool) {
        return priceOracleOf[_asset] != address(0) || _asset == base;
    }

    /// @inheritdoc IPriceOracle
    function refreshedAssetPerBaseInUQ(address _asset) public override returns (uint) {
        if (_asset == base) {
            return FixedPoint112.Q112;
        }

        require(priceOracleOf[_asset] != address(0), "PhuturePriceOracle: UNSET");
        return IPriceOracle(priceOracleOf[_asset]).refreshedAssetPerBaseInUQ(_asset);
    }

    /// @inheritdoc IPriceOracle
    function lastAssetPerBaseInUQ(address _asset) public view override returns (uint) {
        if (_asset == base) {
            return FixedPoint112.Q112;
        }

        require(priceOracleOf[_asset] != address(0), "PhuturePriceOracle: UNSET");
        return IPriceOracle(priceOracleOf[_asset]).lastAssetPerBaseInUQ(_asset);
    }

    /// @inheritdoc ERC165Upgradeable
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return
            _interfaceId == type(IPhuturePriceOracle).interfaceId ||
            _interfaceId == type(IPriceOracle).interfaceId ||
            super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc UUPSUpgradeable
    function _authorizeUpgrade(address _newImpl) internal view override onlyRole(ASSET_MANAGER_ROLE) {
        bytes4[] memory interfaceIds = new bytes4[](2);
        interfaceIds[0] = type(IPriceOracle).interfaceId;
        interfaceIds[1] = type(IPhuturePriceOracle).interfaceId;
        require(_newImpl.supportsAllInterfaces(interfaceIds), "PhuturePriceOracle: INTERFACE");

        super._authorizeUpgrade(_newImpl);
    }

    uint256[48] private __gap;
}
