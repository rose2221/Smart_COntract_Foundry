//SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol"

pragma solidity ^0.8.18;

contract HelperConfig is Script{
    struct NetworkCOnfig{
        uint256 entranceFee;
         uint256 interval;
         address vrfCoordinator;
          bytes32 callbackGasLimit;
            uint256  subscriptionId;
             bytes32 gasLane ;
             uint64 subscriptionId;
    }
    NetworkConfig public activeNetworkConfig;
    constructor(){
        if (block.chainid = 1115111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public view pure returns(NetworkCOnfig memory){
        return NetworkCOnfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(vrfCoordinatorMock),
            callbackGasLimit: 500000,
            subscriptionId: 0,
            gasLane: bytes32(0),
            subscriptionId: 0
        });
    }
     function getAnvilEthConfig() public view returns(NetworkCOnfig memory){
        if(activeNetworkConfig.vrfCoordinator != address(0)){
            return activeNetworkConfig;
        }
        uint96 basFee = 0.25 ether;
        uint96 gasPriceLink = 1e9;
        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock();
        vm.stopBroadcast();
    }
}