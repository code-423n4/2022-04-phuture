// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.8.7;

import "./IvToken.sol";
import "./IPhuturePriceOracle.sol";

/// @title Orderer interface
/// @notice Describes methods for reweigh execution, order creation and execution
interface IOrderer {
    enum OrderSide {
        Sell,
        Buy
    }

    event PlaceOrder(address creator, uint id);
    event UpdateOrder(uint id, address asset, uint share, bool isSellSide);
    event CompleteOrder(uint id, address sellAsset, uint soldShares, address buyAsset, uint boughtShares);

    /// @notice Initializes orderer with the given params
    /// @param _registry Index registry address
    /// @param _orderLifetime Order lifetime in which it stays valid
    /// @param _maxAllowedPriceImpactInBP Max allowed exchange price impact
    function initialize(
        address _registry,
        uint64 _orderLifetime,
        uint16 _maxAllowedPriceImpactInBP
    ) external;

    /// @notice Sets max allowed exchange price impact
    /// @param _maxAllowedPriceImpactInBP Max allowed exchange price impact
    function setMaxAllowedPriceImpactInBP(uint16 _maxAllowedPriceImpactInBP) external;

    /// @notice Sets order lifetime in which it stays valid
    /// @param _orderLifetime Order lifetime in which it stays valid
    function setOrderLifetime(uint64 _orderLifetime) external;

    /// @notice Places order to orderer queue and returns order id
    /// @return Order id of the placed order
    function placeOrder() external returns (uint);

    /// @notice Fulfills specified order with order details
    /// @param _orderId Order id to fulfill
    /// @param _asset Asset address to be exchanged
    /// @param _shares Amount of asset to be exchanged
    /// @param _side Order side: buy or sell
    function addOrderDetails(
        uint _orderId,
        address _asset,
        uint _shares,
        OrderSide _side
    ) external;

    /// @notice Updates asset amount for the latest order placed by the sender
    /// @param _asset Asset to change amount for
    /// @param _newTotalSupply New amount value
    /// @param _oldTotalSupply Old amount value
    function reduceOrderAsset(
        address _asset,
        uint _newTotalSupply,
        uint _oldTotalSupply
    ) external;

    /// @notice Returns last order id of the given account
    /// @param _account Account to get last order for
    /// @return Last order id of the given account
    function lastOrderIdOf(address _account) external view returns (uint);
}
