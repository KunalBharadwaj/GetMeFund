# GetMeFund Smart Contract

GetMeFund is a decentralized crowdfunding smart contract deployed on the Sepolia testnet. It allows users to fund the project with ETH while ensuring a minimum USD value for each contribution.

## Contract Address

- **Sepolia Testnet**: [0x8cDD39c51E1d6d48B1538655dc550422247E4546](https://sepolia.etherscan.io/address/0x8cDD39c51E1d6d48B1538655dc550422247E4546)

## Features

- **Minimum Funding Requirement**: Each contribution must be worth at least 5 USD in ETH
- **Price Oracle Integration**: Uses Chainlink Price Feeds for accurate ETH/USD conversion
- **Transparent Funding**: All funders' addresses and contribution amounts are publicly accessible
- **Owner-Only Withdrawal**: Only the contract owner can withdraw accumulated funds

## How It Works

### Funding

Users can fund the project by:

1. Directly calling the `fund()` function with ETH attached
2. Sending ETH directly to the contract address (triggers `receive()` or `fallback()`)

Each contribution must be worth at least 5 USD based on current ETH/USD price.

### Price Conversion

The contract uses Chainlink's ETH/USD Price Feed (Sepolia testnet) to ensure accurate price conversion:

- `getPrice()` - Returns the current ETH/USD price from Chainlink
- `getTotalAmount(uint256 _ethInWei)` - Converts ETH amount to USD equivalent

### Withdrawal

The contract owner can withdraw all funds by calling the `withdraw()` function. This function:
1. Resets all funder balances to zero
2. Clears the funders array
3. Transfers all contract balance to the owner

## For Developers

### Constructor

Initializes the contract with:
- Chainlink ETH/USD Price Feed: `0x694AA1769357215DE4FAC081bf1f309aDC325306` (Sepolia)
- Sets the deploying address as the contract owner

### Key Functions

- `fund() payable` - Contribute ETH to the project
- `withdraw()` - Owner-only function to withdraw all funds
- `getPrice() returns (uint256)` - Get current ETH/USD price
- `getTotalAmount(uint256 _ethInWei) returns (uint256)` - Convert ETH to USD value

### State Variables

- `MINIMUM_USD = 5` - Minimum contribution in USD
- `i_owner` - Immutable contract owner address
- `funders` - Array of all contributor addresses
- `addressToAmountFunded` - Mapping of contributor addresses to their total contributed amount

## How to Interact

You can interact with the contract through:
1. Etherscan's "Write Contract" tab
2. Web3 libraries like ethers.js or web3.js
3. Directly sending ETH to the contract address

## Security Features

- `onlyOwner` modifier ensures withdrawal function is restricted
- Uses Chainlink oracle to prevent price manipulation
- Input validation for minimum contribution amounts

## Requirements

Built with:
- Solidity ^0.8.30
- Chainlink Price Feed Oracle
