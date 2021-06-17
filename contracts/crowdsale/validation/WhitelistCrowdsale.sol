// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../Crowdsale.sol";
import "../access/WhitelistedRole.sol";

/**
 * @title WhitelistCrowdsale
 * @dev Crowdsale in which only whitelisted users can contribute.
 */
abstract contract WhitelistCrowdsale is WhitelistedRole, Crowdsale {
  /**
   * @dev Extend parent behavior requiring beneficiary to be whitelisted. Note that no
   * restriction is imposed on the account sending the transaction.
   * @param _beneficiary Token beneficiary
   */
  function _preValidatePurchase(
    address _beneficiary,
    uint256 /* _weiAmount */
  ) internal view virtual override {
    require(
      isWhitelisted(_beneficiary),
      "WhitelistCrowdsale: beneficiary doesn't have the Whitelisted role"
    );
  }
}
