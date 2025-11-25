# LISA Token

An upgradeable ERC20/BEP20 token built with Foundry for deployment on Binance Smart Chain (BSC).

## Features

- **Upgradeable**: Uses UUPS (Universal Upgradeable Proxy Standard) pattern
- **ERC20/BEP20 Compatible**: Full ERC20 standard with BEP20 `getOwner()` function
- **Burnable**: Token holders can burn their tokens
- **Pausable**: Owner can pause/unpause all transfers in case of emergency
- **Owner Controlled**: Critical functions restricted to owner
- **Initial Supply**: 1,000,000,000 LISA tokens (1 billion)

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [pnpm](https://pnpm.io/installation)
- Node.js v16 or higher

## Installation

1. Clone the repository and install dependencies:

```bash
pnpm install
```

2. Copy the environment file and configure it:

```bash
cp .env.example .env
```

3. Edit `.env` and fill in your values:

```env
BSC_RPC_URL=https://bsc-dataseed.binance.org/
BSCSCAN_API_KEY=your_bscscan_api_key
PRIVATE_KEY=your_private_key
INITIAL_OWNER=address_to_receive_initial_supply
```

## Project Structure

```
.
├── src/
│   └── LISAToken.sol          # Main upgradeable token contract
├── script/
│   ├── DeployLISA.s.sol       # Deployment script
│   └── UpgradeLISA.s.sol      # Upgrade script
├── test/
│   └── LISAToken.t.sol        # Comprehensive test suite
├── foundry.toml               # Foundry configuration
├── remappings.txt             # Import remappings
└── package.json               # pnpm scripts
```

## Building

Compile the contracts:

```bash
pnpm build
```

## Testing

Run the test suite:

```bash
pnpm test
```

Run tests with gas reporting:

```bash
pnpm test:gas
```

Generate coverage report:

```bash
pnpm coverage
```

## Deployment

### Deploy to BSC Mainnet

1. Ensure your `.env` file is properly configured with:
   - `BSC_RPC_URL`: BSC mainnet RPC endpoint
   - `BSCSCAN_API_KEY`: API key for contract verification
   - `PRIVATE_KEY`: Deployer's private key (must have BNB for gas)
   - `INITIAL_OWNER`: Address that will receive the initial token supply

2. Dry run (simulation without broadcasting):

```bash
pnpm deploy:bsc:dry
```

3. Deploy to BSC mainnet:

```bash
pnpm deploy:bsc
```

This will:
- Deploy the implementation contract
- Deploy the ERC1967 proxy
- Initialize the token with 1B LISA tokens
- Verify contracts on BSCScan
- Display all deployment addresses

**Important**: Save the proxy address and implementation address from the deployment output!

### Deploy to BSC Testnet

For testing on BSC testnet:

```bash
pnpm deploy:testnet
```

## Upgrading

To upgrade the token implementation:

1. Set the `PROXY_ADDRESS` in your `.env`:

```env
PROXY_ADDRESS=0x... # Your deployed proxy address
```

2. Dry run the upgrade:

```bash
pnpm upgrade:bsc:dry
```

3. Execute the upgrade:

```bash
pnpm upgrade:bsc
```

**Note**: Only the contract owner can execute upgrades.

## Contract Addresses

After deployment, record your addresses here:

- **BSC Mainnet Proxy**: TBD
- **BSC Mainnet Implementation**: TBD

## Key Functions

### User Functions

- `transfer(address to, uint256 amount)`: Transfer tokens
- `approve(address spender, uint256 amount)`: Approve spending
- `transferFrom(address from, address to, uint256 amount)`: Transfer from approved address
- `burn(uint256 amount)`: Burn your tokens

### Owner Functions

- `pause()`: Pause all token transfers
- `unpause()`: Resume token transfers
- `upgradeToAndCall(address newImplementation, bytes data)`: Upgrade contract

### View Functions

- `name()`: Returns "LISA Token"
- `symbol()`: Returns "LISA"
- `decimals()`: Returns 18
- `totalSupply()`: Returns current total supply
- `balanceOf(address account)`: Returns account balance
- `getOwner()`: Returns owner address (BEP20 compatibility)

## Security Considerations

1. **Private Key Security**: Never commit your `.env` file or expose your private key
2. **Testnet Testing**: Always test on BSC testnet before mainnet deployment
3. **Upgrade Authorization**: Only the owner can upgrade the contract
4. **Pause Mechanism**: Owner can pause transfers in case of emergency
5. **Audit**: Consider getting a professional audit before mainnet deployment

## Gas Estimates

Approximate gas costs on BSC:

- Deployment: ~2.5M gas
- Transfer: ~50k gas
- Approve: ~45k gas
- Burn: ~40k gas

## Verification

Contracts are automatically verified on BSCScan during deployment. To manually verify:

```bash
forge verify-contract <address> src/LISAToken.sol:LISAToken \
  --chain-id 56 \
  --etherscan-api-key $BSCSCAN_API_KEY
```

## Development

Format code:

```bash
pnpm format
```

Check formatting:

```bash
pnpm format:check
```

Clean build artifacts:

```bash
pnpm clean
```

## License

MIT

## Support

For issues and questions, please open an issue on GitHub.
