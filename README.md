# ✨ So you want to sponsor a contest

This `README.md` contains a set of checklists for our contest collaboration.

Your contest will use two repos: 
- **a _contest_ repo** (this one), which is used for scoping your contest and for providing information to contestants (wardens)
- **a _findings_ repo**, where issues are submitted. 

Ultimately, when we launch the contest, this contest repo will be made public and will contain the smart contracts to be reviewed and all the information needed for contest participants. The findings repo will be made public after the contest is over and your team has mitigated the identified issues.

Some of the checklists in this doc are for **C4 (🐺)** and some of them are for **you as the contest sponsor (⭐️)**.

---

# Contest setup

## ⭐️ Sponsor: Provide contest details

Under "SPONSORS ADD INFO HERE" heading below, include the following:

- [ ] Name of each contract and:
  - [ ] source lines of code (excluding blank lines and comments) in each
  - [ ] external contracts called in each
  - [ ] libraries used in each
- [ ] Describe any novel or unique curve logic or mathematical models implemented in the contracts
- [ ] Does the token conform to the ERC-20 standard? In what specific ways does it differ?
- [ ] Describe anything else that adds any special logic that makes your approach unique
- [ ] Identify any areas of specific concern in reviewing the code
- [ ] Add all of the code to this repo that you want reviewed
- [ ] Create a PR to this repo with the above changes.

# Contest prep

## ⭐️ Sponsor: Contest prep
- [ ] Make sure your code is thoroughly commented using the [NatSpec format](https://docs.soliditylang.org/en/v0.5.10/natspec-format.html#natspec-format).
- [ ] Modify the bottom of this `README.md` file to describe how your code is supposed to work with links to any relevent documentation and any other criteria/details that the C4 Wardens should keep in mind when reviewing. ([Here's a well-constructed example.](https://github.com/code-423n4/2021-06-gro/blob/main/README.md))
- [ ] Please have final versions of contracts and documentation added/updated in this repo **no less than 8 hours prior to contest start time.**
- [ ] Ensure that you have access to the _findings_ repo where issues will be submitted.
- [ ] Promote the contest on Twitter (optional: tag in relevant protocols, etc.)
- [ ] Share it with your own communities (blog, Discord, Telegram, email newsletters, etc.)
- [ ] Optional: pre-record a high-level overview of your protocol (not just specific smart contract functions). This saves wardens a lot of time wading through documentation.
- [ ] Designate someone (or a team of people) to monitor DMs & questions in the C4 Discord (**#questions** channel) daily (Note: please *don't* discuss issues submitted by wardens in an open channel, as this could give hints to other wardens.)
- [ ] Delete this checklist and all text above the line below when you're ready.

---

# Phuture Finance contest details
- $27,000 USDC main award pot
- $3,000 USDC gas optimization award pot
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2022-03-phuture-finance-contest/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts April 19, 2022 00:00 UTC
- Ends April 21, 2022 23:59 UTC

This repo will be made public before the start of the contest. (C4 delete this line when made public)

| Glossary| |
|-------------------------------|------------------------------------------------------|
| BP | Base points = 10000 - not to be confused with basis points |
| vTokens| Vault tokens that are created for each asset in a vault|
| NAV| Net Asset Value - the summation of the value of each token within an index |
| Managed Index| An index where the creator can control weights and assets |
| Tracked Index| An index where assets are immutable after creation but weights change based on stored/updated capitalisation data |
| TopN Index | An index where both weights and assets are programmtically decided based on a categories contract |

# Contest Scope
Representatives from Phuture will be available in the Code Arena Discord to answer any questions during the contest period. The focus for the contest is to try and find any logic errors or ways to drain funds from the protocol in a way that is advantageous for an attacker at the expense of users with funds invested in the protocol. Wardens should assume that governance variables are set sensibly (unless they can find a way to change the value of a governance variable, and not counting social engineering approaches for this). 

# Protocol Overview
Phuture is an asset management protocol initially focused on crypto index products.

Our protocol provides the functionality to mint, redeem and create index products. We utilise a vault design to store the underlying assets of the index and these vaults can have additional "controllers" added to them to support extra functionality or strategies. At launch we have integrated a yearn vault controller that allows us to move some of the index funds over to yearn to earn additional interest. vTokens are created for  each token held in a vault and allow us to account for assets which are held in our contracts plus the contracts of other protocols (such as yearn).

Rebalancing of these indices is executed against the liquidity held on Uniswap v2 and Sushiswap. Our contracts create a set of orders for each index that will bring that index back to it's correct balance. These orders are then executed by our keeper. In most cases, orders are too large to execute in one go due to price impact, so our smart contracts scale the orders down to adhere to a specific price impact.

Fees are taken during the minting and redemption process. In addition, we charge a fee annually for the management of the index products. 

The protocol's base curreency is USDC and as such the net asset value of each index is calculated in USDC. 


# Smart Contracts
All the contracts in this section are to be reviewed. Any contracts not in this list are to be ignored for this contest.

# Potential Protocol concerns
- Minting - minted share accounting
- Burning - burned share accounting
- Price oracle exploitation between mints and burns
- AUM calculations in-between index transfers
- Active and inactive assets - inclusion of inactive assets might affect minting and burning fee evaluations
- Inclusion and exclusion of index assets (during reweighs and how can it affect the minting/burning accounting logic)
- delegatecall proxying
- Reweighting logic - how buy/sell order deltas are calculated
- vToken - NAV calculation logic during minting
- vToken - shareChange calculation
- vToken - updateDeposit deposition logic that tracks target utilisation of liquidity on yearn

# Areas of concern for Wardens
We would like wardens to focus on any core functional logic, boundary case errors or similar issues which could be utilized by an attacker to take funds away from clients who have funds deposited in the protocol. That said any errors may be submitted by wardens for review and potential reward as per the normal issue impact prioritization. Gas optimizations are welcome but not the main focus of this contest and thus at most 10% of the contest reward will be allocated to gas optimizations. For gas optimizations the most important flows are client deposit and withdrawal flows.

If wardens are unclear on which areas to look at or which areas are important please feel free to ask in the contest Discord channel.



