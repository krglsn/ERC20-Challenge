pragma solidity ^0.8.24;

import "Challenge/ERC20-Challenge.sol";
import "../lib/openzeppelin-contracts/lib/forge-std/src/Test.sol";

contract MyTokenTest is Test {

    uint256 public testNumber;
    uint256 public totalSupply;
    MyToken public token;
    address public master;

    function setUp() public {
        master = makeAddr("krglsn");
        startHoax(master);
        testNumber = 42;
        totalSupply = 13000;
        token = new MyToken(totalSupply);
    }

    function test_constructor() public {
        assertEq(token.totalSupply(), totalSupply);
        assertEq(token.symbol(), "KRG");
        assertEq(token.name(), "KRGLSN TOKEN");
        assertEq(token.getBalanceOf(master), totalSupply);
    }

    function test_mint_burn() public {
        address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        token.mint(alice, 500e18);
        vm.startPrank(alice);
        vm.expectRevert();
        token.mint(alice, 500e18);
        assertEq(token.getBalanceOf(alice), 500e18);
        vm.expectRevert();
        token.burn(alice, 100);
        vm.startPrank(master);
        token.burn(alice, 100e18);
        assertEq(token.getBalanceOf(alice), 400e18);
    }

    function test_mint_too_much() public {
        //TODO
    }

    function test_burn_too_much() public {
        //TODO
    }

    function transfer_more_than_have() public {
        //TODO
    }

    function test_transfer() public {
        address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address bob = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);
        token.mint(alice, 1000);
        vm.startPrank(alice);
        token.transfer(bob, 500);
        assertEq(token.balanceOf(alice), 500);
        assertEq(token.balanceOf(bob), 500);
    }

    function test_transfer_from_no_allowance() public {
        address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address bob = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        address mike = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);
        token.mint(alice, 1000);
        vm.startPrank(mike);
        vm.expectRevert();
        token.transferFrom(alice, bob, 500);
        assertEq(token.balanceOf(alice), 1000);
        assertEq(token.balanceOf(bob), 0);
    }

    function test_transfer_from_low_allowance() public {
        address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address bob = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        address mike = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);
        token.mint(alice, 1000);
        vm.startPrank(alice);
        token.approve(mike, 200);
        vm.startPrank(mike);
        vm.expectRevert();
        token.transferFrom(alice, bob, 500);
        assertEq(token.balanceOf(alice), 1000);
        assertEq(token.balanceOf(bob), 0);
        token.transferFrom(alice, bob, 200);
        assertEq(token.balanceOf(alice), 800);
        assertEq(token.balanceOf(bob), 200);
    }

    function test_transfer_from_exhausted_allowance() public {
        address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address bob = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        address mike = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 0);
        token.mint(alice, 1000);
        vm.startPrank(alice);
        token.approve(mike, 200);
        vm.startPrank(mike);
        token.transferFrom(alice, bob, 150);
        assertEq(token.balanceOf(alice), 850);
        assertEq(token.balanceOf(bob), 150);
        vm.expectRevert();
        token.transferFrom(alice, bob, 100);
        assertEq(token.balanceOf(alice), 850);
        assertEq(token.balanceOf(bob), 150);
        vm.startPrank(alice);
        token.transfer(bob, 600);
        assertEq(token.getBalanceOf(alice), 250);
        assertEq(token.getBalanceOf(bob), 750);
    }


}

