// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/LISAToken.sol";

/**
 * @title DeployLISA
 * @dev Deployment script for LISA Token with UUPS proxy on BSC
 *
 * Usage:
 * forge script script/DeployLISA.s.sol:DeployLISA --rpc-url $BSC_RPC_URL --broadcast --verify -vvvv
 */
contract DeployLISA is Script {
    function run() external {
        // Load environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address initialOwner = vm.envAddress("INITIAL_OWNER");

        console.log("Deploying LISA Token to BSC Mainnet");
        console.log("Deployer:", vm.addr(deployerPrivateKey));
        console.log("Initial Owner:", initialOwner);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy implementation
        LISAToken implementation = new LISAToken();
        console.log("Implementation deployed at:", address(implementation));

        // Prepare initialization data
        bytes memory initData = abi.encodeWithSelector(
            LISAToken.initialize.selector,
            initialOwner
        );

        // Deploy proxy
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(implementation),
            initData
        );
        console.log("Proxy deployed at:", address(proxy));

        // Wrap proxy in token interface
        LISAToken token = LISAToken(address(proxy));

        // Verify deployment
        console.log("\n=== Deployment Verification ===");
        console.log("Token Name:", token.name());
        console.log("Token Symbol:", token.symbol());
        console.log("Total Supply:", token.totalSupply());
        console.log("Owner:", token.owner());
        console.log("Initial Owner Balance:", token.balanceOf(initialOwner));

        vm.stopBroadcast();

        console.log("\n=== Deployment Complete ===");
        console.log("LISA Token Proxy Address:", address(proxy));
        console.log("LISA Token Implementation Address:", address(implementation));
        console.log("\nSave these addresses for future upgrades!");
    }
}
