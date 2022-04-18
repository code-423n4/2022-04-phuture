// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.8.7;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165CheckerUpgradeable.sol";

import "./interfaces/IGasPriceOracle.sol";

/// @title Base fee gas price oracle
/// @dev Returns the value of the base fee for the current block
abstract contract BaseFeeGasPriceOracle is IGasPriceOracle, UUPSUpgradeable, ERC165Upgradeable {
    using ERC165CheckerUpgradeable for address;

    /// @notice Additional fee that is paid to motivate miners to include transaction in a block
    uint public constant MAX_PRIORITY_FEE = 2 gwei;

    /// @inheritdoc IGasPriceOracle
    function getFastGasInWei() public view override returns (uint) {
        return (2 * block.basefee) + MAX_PRIORITY_FEE;
    }

    /// @inheritdoc ERC165Upgradeable
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return _interfaceId == type(IGasPriceOracle).interfaceId || super.supportsInterface(_interfaceId);
    }

    /// @notice Initializes base gas fee price oracle
    function __BaseFeeGasPriceOracle_init() internal onlyInitializing {
        __UUPSUpgradeable_init();
        __ERC165_init();
    }

    /// @inheritdoc UUPSUpgradeable
    function _authorizeUpgrade(address _newImpl) internal view virtual override {
        require(_newImpl.supportsInterface(type(IGasPriceOracle).interfaceId), "BaseFeeGasPriceOracle: INTERFACE");
    }

    uint256[50] private __gap;
}
