// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./crowdsale/Crowdsale.sol";
import "./crowdsale/Ownable.sol";
import "./crowdsale/emission/AllowanceCrowdsale.sol";
import "./crowdsale/validation/CappedCrowdsale.sol";
import "./crowdsale/validation/TimedCrowdsale.sol";
import "./crowdsale/validation/WhitelistCrowdsale.sol";

contract PCrowdsale is
  Crowdsale,
  Ownable,
  AllowanceCrowdsale,
  CappedCrowdsale,
  TimedCrowdsale,
  WhitelistCrowdsale
{
  using SafeMath for uint256;

  uint256 public perBeneficiaryCap;

  mapping(address => uint256) public contribution;

  constructor(
    uint256 rate,
    IERC20 token,
    address tokenWallet,
    uint256 cap,
    uint256 openingTime,
    uint256 closingTime,
    uint256 _perBeneficiaryCap
  )
    Crowdsale(rate, payable(this), token)
    AllowanceCrowdsale(tokenWallet)
    CappedCrowdsale(cap)
    TimedCrowdsale(openingTime, closingTime)
    WhitelistAdminRole()
  {
    perBeneficiaryCap = _perBeneficiaryCap;
  }

  function _deliverTokens(address beneficiary, uint256 tokenAmount)
    internal
    override(Crowdsale, AllowanceCrowdsale)
  {
    AllowanceCrowdsale._deliverTokens(beneficiary, tokenAmount);
  }

  function _preValidatePurchase(address beneficiary, uint256 weiAmount)
    internal
    view
    override(Crowdsale, CappedCrowdsale, TimedCrowdsale, WhitelistCrowdsale)
  {
    require(
      contribution[beneficiary].add(weiAmount) <= perBeneficiaryCap,
      "Contribution above cap."
    );

    CappedCrowdsale._preValidatePurchase(beneficiary, weiAmount);
    TimedCrowdsale._preValidatePurchase(beneficiary, weiAmount);
    WhitelistCrowdsale._preValidatePurchase(beneficiary, weiAmount);
  }

  function withdraw() public payable onlyOwner {
    require(block.timestamp >= closingTime(), "TimeCrowdsale should be closed");
    payable(owner()).transfer(address(this).balance);
  }

  function _updatePurchasingState(address beneficiary, uint256 weiAmount)
    internal
    override
  {
    contribution[beneficiary] = contribution[beneficiary].add(weiAmount);
  }
}
