//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Test, console} from "forge-std/Test.sol";

contract RaffleTest is Test {
    Raffle raffle;
    address public PLAYER= makeAddr("player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    function setUp() external {
        DeployRaffle deployer = new DeployerRaffle();
        (raffle, helperConfig) = deployer.run();
        ( entranceFee;
           interval;
          vrfCoordinator;
           callbackGasLimit;
            subscriptionId;
             gasLane) = helperconfig.activateNetworkConfig();
    }
    function testRaffleIntialization() public {
          assertEq(raffle.getRaffleState(), Raffle.RaffleState.OPEN
          );
        assertEq(raffle.i_entranceFee(), entranceFee);
        assertEq(raffle.i_interval(), interval);
        assertEq(raffle.i_vrfCoordinator(), vrfCoordinator);
        assertEq(raffle.i_callbackGasLimit(), callbackGasLimit);
        assertEq(raffle.i_subscriptionId(), subscriptionId);
        assertEq(raffle.i_gasLane(), gasLane);
        assertEq(raffle.s_raffleState(), Raffle.RaffleState.OPEN);
    }

    function testrafflerevertwhenyoudontpayenough() public {
        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle__NotEnoughEthSent.selector);

         raffle.enterRaffle();
        // assertEq(raffle.s_players().length, 0);
    }
    function testrafflerecordsplayerwhentheyenter() public {
        vm.prank(PLAYER);
        raffle.enterRaffle
    }
}