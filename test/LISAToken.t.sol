// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/LISAToken.sol";

contract LISATokenTest is Test {
    LISAToken public token;
    LISAToken public implementation;
    ERC1967Proxy public proxy;

    address public owner = address(1);
    address public user1 = address(2);
    address public user2 = address(3);

    uint256 constant INITIAL_SUPPLY = 1_000_000_000 * 10 ** 18; // 1 billion tokens

    function setUp() public {
        // Deploy implementation
        implementation = new LISAToken();

        // Prepare initialization data
        bytes memory initData = abi.encodeWithSelector(
            LISAToken.initialize.selector,
            owner
        );

        // Deploy proxy
        proxy = new ERC1967Proxy(address(implementation), initData);

        // Wrap proxy in token interface
        token = LISAToken(address(proxy));
    }

    function testInitialState() public view {
        assertEq(token.name(), "LISA Token");
        assertEq(token.symbol(), "LISA");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
        assertEq(token.owner(), owner);
    }

    function testTransfer() public {
        uint256 amount = 1000 * 10 ** 18;

        vm.prank(owner);
        bool success = token.transfer(user1, amount);

        assertTrue(success);
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
    }

    function testApproveAndTransferFrom() public {
        uint256 amount = 1000 * 10 ** 18;

        // Owner approves user1 to spend tokens
        vm.prank(owner);
        token.approve(user1, amount);

        assertEq(token.allowance(owner, user1), amount);

        // User1 transfers from owner to user2
        vm.prank(user1);
        bool success = token.transferFrom(owner, user2, amount);

        assertTrue(success);
        assertEq(token.balanceOf(user2), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
        assertEq(token.allowance(owner, user1), 0);
    }

    function testBurn() public {
        uint256 burnAmount = 1000 * 10 ** 18;

        vm.prank(owner);
        token.burn(burnAmount);

        assertEq(token.totalSupply(), INITIAL_SUPPLY - burnAmount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - burnAmount);
    }

    function testPauseUnpause() public {
        uint256 amount = 1000 * 10 ** 18;

        // Pause transfers
        vm.prank(owner);
        token.pause();

        // Try to transfer while paused (should fail)
        vm.prank(owner);
        vm.expectRevert();
        token.transfer(user1, amount);

        // Unpause
        vm.prank(owner);
        token.unpause();

        // Transfer should work now
        vm.prank(owner);
        bool success = token.transfer(user1, amount);
        assertTrue(success);
    }

    function testOnlyOwnerCanPause() public {
        vm.prank(user1);
        vm.expectRevert();
        token.pause();
    }

    function testBEP20Compatibility() public view {
        // Test getOwner function for BEP20 compatibility
        assertEq(token.getOwner(), owner);
    }

    function testUpgrade() public {
        // Deploy new implementation
        LISAToken newImplementation = new LISAToken();

        // Upgrade
        vm.prank(owner);
        token.upgradeToAndCall(address(newImplementation), "");

        // Verify state is preserved
        assertEq(token.name(), "LISA Token");
        assertEq(token.symbol(), "LISA");
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
    }

    function testOnlyOwnerCanUpgrade() public {
        LISAToken newImplementation = new LISAToken();

        vm.prank(user1);
        vm.expectRevert();
        token.upgradeToAndCall(address(newImplementation), "");
    }

    function testCannotReinitialize() public {
        vm.prank(owner);
        vm.expectRevert();
        token.initialize(user1);
    }
}
