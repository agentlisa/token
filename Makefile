.PHONY: help install build test test-gas coverage clean deploy-bsc deploy-testnet deploy-dry upgrade-bsc upgrade-dry format format-check

# Load environment variables
include .env
export

help: ## Display this help message
	@echo "LISA Token - Makefile Commands"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	pnpm install

build: ## Build the project
	forge build

test: ## Run tests
	forge test -vvv

test-gas: ## Run tests with gas reporting
	forge test --gas-report

coverage: ## Generate coverage report
	forge coverage

clean: ## Clean build artifacts
	forge clean

deploy-bsc: ## Deploy to BSC mainnet (with verification)
	forge script script/DeployLISA.s.sol:DeployLISA --rpc-url $(BSC_RPC_URL) --broadcast --verify -vvvv

deploy-testnet: ## Deploy to BSC testnet (with verification)
	forge script script/DeployLISA.s.sol:DeployLISA --rpc-url $(BSC_TESTNET_RPC_URL) --broadcast --verify -vvvv

deploy-dry: ## Dry run deployment (no broadcast)
	forge script script/DeployLISA.s.sol:DeployLISA --rpc-url $(BSC_RPC_URL) -vvvv

upgrade-bsc: ## Upgrade token on BSC mainnet
	@if [ -z "$(PROXY_ADDRESS)" ]; then echo "Error: PROXY_ADDRESS not set in .env"; exit 1; fi
	forge script script/UpgradeLISA.s.sol:UpgradeLISA --rpc-url $(BSC_RPC_URL) --broadcast --verify -vvvv

upgrade-dry: ## Dry run upgrade (no broadcast)
	@if [ -z "$(PROXY_ADDRESS)" ]; then echo "Error: PROXY_ADDRESS not set in .env"; exit 1; fi
	forge script script/UpgradeLISA.s.sol:UpgradeLISA --rpc-url $(BSC_RPC_URL) -vvvv

format: ## Format code
	forge fmt

format-check: ## Check code formatting
	forge fmt --check

verify: ## Verify contract on BSCScan (requires CONTRACT_ADDRESS)
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "Error: CONTRACT_ADDRESS not set"; exit 1; fi
	forge verify-contract $(CONTRACT_ADDRESS) src/LISAToken.sol:LISAToken --chain-id 56 --etherscan-api-key $(BSCSCAN_API_KEY)
