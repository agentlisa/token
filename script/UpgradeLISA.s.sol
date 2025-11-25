// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/LISAToken.sol";

/**
 * @title UpgradeLISA
 * @dev Script for upgrading LISA Token implementation
 *
 * Usage:
 * PROXY_ADDRESS=0x... forge script script/UpgradeLISA.s.sol:UpgradeLISA --rpc-url $BSC_RPC_URL --broadcast --verify -vvvv
 */
contract UpgradeLISA is Script {
    function run() external {
        // Load environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        console.log("Upgrading LISA Token on BSC Mainnet");
        console.log("Upgrader:", vm.addr(deployerPrivateKey));
        console.log("Proxy Address:", proxyAddress);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy new implementation
        LISAToken newImplementation = new LISAToken();
        console.log("New Implementation deployed at:", address(newImplementation));

        // Get the existing proxy
        LISAToken token = LISAToken(proxyAddress);

        // Upgrade to new implementation
        token.upgradeToAndCall(address(newImplementation), "");

        vm.stopBroadcast();

        console.log("\n=== Upgrade Verification ===");
        console.log("Token Name:", token.name());
        console.log("Token Symbol:", token.symbol());
        console.log("Total Supply:", token.totalSupply());
        console.log("Owner:", token.owner());

        console.log("\n=== Upgrade Complete ===");
        console.log("Proxy Address (unchanged):", proxyAddress);
        console.log("New Implementation Address:", address(newImplementation));
    }
}
