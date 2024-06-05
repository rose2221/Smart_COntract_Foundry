//SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

pragma solidity ^0.8.18;

contract DeployRaffle is Script {
    Raffle public raffle;

    constructor() {
        raffle = new Raffle(1, 2, address(0), bytes32(0), 0, bytes32(0));
    }

    function run() external returns (Raffle, HelperConfig ){
        HelperConfighelperconfig = new HelperConfig();(
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinator,
            bytes32 callbackGasLimit,
            uint256 subscriptionId,
            bytes32 gasLane
        ) = helperconfig.activeNetworkConfig();
        vm.startBroadcast();
        Raffle raffle new Raffle(entranceFee, interval, vrfCoordinator, callbackGasLimit, subscriptionId, gasLane);

        vm.stopBroadcast();
        return (raffle, helperconfig);}

}