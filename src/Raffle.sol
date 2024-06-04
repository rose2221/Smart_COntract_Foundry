//SPDX-License-Identifier: MIT

/**constructor

receive function (if exists)

fallback function (if exists)

external

public

internal

private
*/

pragma solidity ^0.8.0;
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Raffle is VRFConsumerBaseV2Plus{
    error Raffle_NotEnoghETH();
    error Raffle_TransferFailed();
    error Raffle_RaffleNotOpen();

    enum RaffleState {
        OPEN, CALCULATING
    }

    address[ ] private s_players;
    
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    address private immutable i_vrfCoordinator;
    uint32 public  immutable i_callbackGasLimit = 100000;
     uint256 public immutable i_subscriptionId;
     address private s_recentWinner;
uint32 public  immutable i_gasLane;
RaffleState private s_raffleState;
    // The default is 3, but you can set this higher.
    uint16 public constant REQUEST_CONFIRMATIONS = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2_5.MAX_NUM_WORDS.
    uint32 public constant NUM_WORDS = 1;

   event EnteredRaffle(
    address indexed player
   );
   event WinnerPicked(address payable winner);
      constructor(uint256 entranceFee, uint256 interval, address vrfCoordinator, bytes32 callbackGasLimit,  uint256  subscriptionId, bytes32 gasLane  ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = vrfCoordinator;
        i_callbackGasLimit = callbackGasLimit; 
        i_subscriptionId=  subscriptionId;
        i_gasLane = gasLane;
        s_raffleState = RaffleState.OPEN;
    }
    
    function getEntranceFee() external view returns(uint256){
        return i_entranceFee;
    }

 

    function enterRaffle() external payable{
if(msg.value < i_entranceFee){
    revert Raffle_NotEnoghETH();
    }
    if(s_raffleState != RaffleState.OPEN){
        revert Raffle_RaffleNotOpen();
    }
    s_players.push(payable(msg.sender));
    emit EnteredRaffle(msg.sender);
    }
    
    function checkUpKeep(bytes memory /*checkData */ )public view returns (bool upKeepNeeded, bytes memory /* performData */){
        bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
           bool isOpen = RaffleState.OPEN == s_raffleStore;
           bool hasBalance = address(this).balance > 0;
           upKeepNeeded = (timeHasPassed && isOpen && hasBalance);
           return (upKeepNeeded, "0x0");
        }

    }
    function pickWinner() public {
    // 1. Makes migration easier
    // 2. makes frontend  "indexing" easier
if(block.timestamp - s_lastTimeStamp < i_interval){
    revert();
}

uint256 requestId = i_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                i_gasLane,
                i_subscriptionId,
                REQUEST_CONFIRMATIONS,
                callbackGasLimit: callbackGasLimit,
                NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            })
        );
    }
      function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
       uint256 indexOfWinner = randomWords[0] % s_players.length;
       address payable winner = s_players[indexOfWinner];
       s_recentWinner = winner;
       s_raffleState = Raffle.OPEN;
       s_players = new address payable[](0);
       s_lastTimeStamp = block.timestamp;
       (bool success,) = winner.call{value: address(this).balance}("");
       if(!success){
        revert Raffle_TransferFailed();
       }
       emit WinnerPicked(winner);
    }
    /**Getter Function */
   
}