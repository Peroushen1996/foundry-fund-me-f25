// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
*/

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() public {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, SEND_VALUE); // fund USER
    }

    function testUserCanFundInteractions() public {
        // USER funds FundMe directly
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        // Withdraw funds using WithdrawFundMe script
        WithdrawFundMe withdrawScript = new WithdrawFundMe();
        withdrawScript.withdrawfundMe(address(fundMe));

        // Assert balance is zero
        assertEq(address(fundMe).balance, 0);
    }
}

/* contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
       vm.deal(USER, STARTING_BALANCE);
    }



   function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.prank(USER);
        vm.deal(USER, 1e18);
        fundFundMe.fundFundMe(address(fundMe));
        vm.stopPrank();

       WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
       withdrawFundMe.withdrawfundMe(address(fundMe));

       assert(address(fundMe).balance == 0);
   }
}
*/

