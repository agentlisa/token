// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title LISAToken
 * @dev Upgradeable ERC20 Token (BEP20 compatible) for BSC
 * Features:
 * - UUPS Upgradeable pattern
 * - Burnable tokens
 * - Pausable transfers
 * - Owner controlled
 */
contract LISAToken is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PausableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract with initial supply
     * @param initialOwner Address that will receive initial supply and own the contract
     */
    function initialize(address initialOwner) public initializer {
        __ERC20_init("LISA Token", "LISA");
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();

        require(initialOwner != address(0), "Owner cannot be zero address");

        // Mint 1 billion tokens (1,000,000,000 * 10^18)
        _mint(initialOwner, 1_000_000_000 * 10 ** decimals());
    }

    /**
     * @dev Pauses all token transfers
     * Can only be called by the owner
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers
     * Can only be called by the owner
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Function that should revert when msg.sender is not authorized to upgrade the contract
     * Called by upgradeToAndCall
     * @param newImplementation Address of the new implementation
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Hook that is called before any transfer of tokens
     * Includes minting and burning
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20Upgradeable, ERC20PausableUpgradeable) {
        super._update(from, to, value);
    }

    /**
     * @dev Returns the BEP20 token owner (for BEP20 compatibility)
     */
    function getOwner() external view returns (address) {
        return owner();
    }
}
