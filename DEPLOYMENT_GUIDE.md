# LISA Token Deployment Guide

## Pre-Deployment Checklist

Before deploying to BSC mainnet, ensure you have:

- [ ] Foundry installed (`curl -L https://foundry.paradigm.xyz | bash && foundryup`)
- [ ] Sufficient BNB in deployer wallet (~0.1 BNB for gas)
- [ ] BSCScan API key (get from https://bscscan.com/myapikey)
- [ ] Configured `.env` file with all required values

## Step-by-Step Deployment

### 1. Environment Setup

Copy and configure the environment file:

```bash
cp .env.example .env
```

Edit `.env` with your values:

```env
# BSC Mainnet RPC (you can use public or private RPC)
BSC_RPC_URL=https://bsc-dataseed.binance.org/

# Get from https://bscscan.com/myapikey
BSCSCAN_API_KEY=YOUR_API_KEY_HERE

# Your deployer wallet private key (DO NOT SHARE!)
PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE

# Address that will receive 1B LISA tokens
INITIAL_OWNER=0xYourAddressHere
```

**Security Warning**: Never commit your `.env` file. It's already in `.gitignore`.

### 2. Install Dependencies

```bash
pnpm install
```

### 3. Build Contracts

```bash
pnpm build
```

Verify build is successful with no errors.

### 4. Run Tests

```bash
pnpm test
```

Ensure all tests pass before deployment.

### 5. Dry Run Deployment

Simulate the deployment without broadcasting:

```bash
pnpm deploy:bsc:dry
```

This will:
- Show you the deployment transaction
- Calculate gas costs
- Verify all parameters
- NOT broadcast to the network

Review the output carefully and ensure everything looks correct.

### 6. Deploy to BSC Mainnet

When ready, execute the real deployment:

```bash
pnpm deploy:bsc
```

Or using Make:

```bash
make deploy-bsc
```

The deployment will:
1. Deploy the LISAToken implementation contract
2. Deploy the ERC1967Proxy contract
3. Initialize the proxy with 1B LISA tokens
4. Transfer ownership to the INITIAL_OWNER address
5. Automatically verify contracts on BSCScan

### 7. Save Deployment Information

After successful deployment, you'll see output like:

```
=== Deployment Complete ===
LISA Token Proxy Address: 0xABC...123
LISA Token Implementation Address: 0xDEF...456

Save these addresses for future upgrades!
```

**IMPORTANT**: Save these addresses securely:
- **Proxy Address**: This is your token's permanent address (users interact with this)
- **Implementation Address**: The logic contract (needed for upgrades)

Add them to your `.env`:

```env
PROXY_ADDRESS=0xYourProxyAddress
```

### 8. Verify Deployment

Check your deployment on BSCScan:

1. Go to https://bscscan.com/address/YOUR_PROXY_ADDRESS
2. Verify the contract is verified (green checkmark)
3. Check the "Read Contract" tab:
   - Name: "LISA Token"
   - Symbol: "LISA"
   - Total Supply: 1,000,000,000 LISA
   - Owner: Your INITIAL_OWNER address

### 9. Test on Block Explorer

On BSCScan, try reading contract functions:

```
balanceOf(INITIAL_OWNER) → Should show 1,000,000,000 * 10^18
name() → "LISA Token"
symbol() → "LISA"
decimals() → 18
getOwner() → INITIAL_OWNER address
```

## Post-Deployment

### Update Documentation

Update the README.md with your deployed addresses:

```markdown
## Contract Addresses

- **BSC Mainnet Proxy**: 0xYourProxyAddress
- **BSC Mainnet Implementation**: 0xYourImplementationAddress
```

### Add to MetaMask

To add LISA token to MetaMask:

1. Open MetaMask
2. Click "Import tokens"
3. Enter Token Address: `YOUR_PROXY_ADDRESS`
4. Token Symbol: LISA
5. Token Decimal: 18

### Create Liquidity

If planning to list on PancakeSwap:

1. Go to PancakeSwap
2. Create a liquidity pair (e.g., LISA/WBNB)
3. Add liquidity with your tokens

## Upgrading the Contract

When you need to upgrade the implementation:

### 1. Modify Contract

Edit `src/LISAToken.sol` with your new features.

### 2. Test Upgrade

Run tests to ensure upgrade compatibility:

```bash
pnpm test
```

### 3. Dry Run Upgrade

```bash
pnpm upgrade:bsc:dry
```

### 4. Execute Upgrade

```bash
pnpm upgrade:bsc
```

**Note**: Only the owner can execute upgrades.

## Troubleshooting

### "insufficient funds for gas"

Ensure your deployer wallet has enough BNB (minimum 0.1 BNB recommended).

### "invalid API key"

Verify your BSCSCAN_API_KEY is correct in `.env`.

### "nonce too low"

If deployment fails and you retry, you may need to reset the nonce or wait a few blocks.

### Verification Failed

If auto-verification fails, manually verify:

```bash
forge verify-contract YOUR_ADDRESS src/LISAToken.sol:LISAToken \
  --chain-id 56 \
  --etherscan-api-key $BSCSCAN_API_KEY
```

## Alternative: Deploy to Testnet First

To test on BSC Testnet first:

1. Get testnet BNB from https://testnet.binance.org/faucet-smart
2. Update `.env` with testnet RPC
3. Deploy:

```bash
pnpm deploy:testnet
```

## BSC Mainnet vs Testnet

| Network | Chain ID | RPC URL | Explorer |
|---------|----------|---------|----------|
| BSC Mainnet | 56 | https://bsc-dataseed.binance.org/ | https://bscscan.com |
| BSC Testnet | 97 | https://data-seed-prebsc-1-s1.binance.org:8545 | https://testnet.bscscan.com |

## Security Checklist

Before going live:

- [ ] All tests passing
- [ ] Tested on testnet
- [ ] Code reviewed
- [ ] Deployment addresses backed up
- [ ] Private keys secured
- [ ] Consider professional audit for production
- [ ] Emergency pause mechanism understood
- [ ] Upgrade process documented
- [ ] Multi-sig wallet for owner (recommended)

## Support

If you encounter issues:

1. Check the [README.md](./README.md)
2. Review Foundry docs: https://book.getfoundry.sh/
3. Check OpenZeppelin docs: https://docs.openzeppelin.com/

## Gas Optimization Tips

- Use BSC's lower gas times (typically late night UTC)
- Check current gas prices: https://bscscan.com/gastracker
- Consider batching operations
- Use a private RPC for faster broadcasting
