// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.7.6;

import "@openzeppelin/contracts/proxy/BeaconProxy.sol";

import "./interfaces/IKatanaV3PoolDeployer.sol";
import "./interfaces/IKatanaV3Factory.sol";

import "./KatanaV3Pool.sol";

contract KatanaV3PoolProxy is BeaconProxy {
  constructor() BeaconProxy(address(0), "") { }

  /// @dev This function will be called with zero arguments but modified to include the pool's immutable parameters.
  function _setBeacon(address beacon, bytes memory data) internal virtual override {
    (address factory, address token0, address token1, uint24 fee, int24 tickSpacing) =
      IKatanaV3PoolDeployer(msg.sender).parameters();

    beacon = IKatanaV3Factory(factory).beacon();
    data = abi.encodeWithSelector(KatanaV3Pool.initializeImmutables.selector, factory, token0, token1, fee, tickSpacing);

    super._setBeacon(beacon, data);
  }
}