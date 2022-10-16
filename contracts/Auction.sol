// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    address public owner;
    uint256 public startBlock;
    uint256 public endBlock;
    uint256 public bidIncrement;

    mapping(address => uint256) fundsByBidder;
    uint256 public highestBindingBid;
    address public highestBidder;
    bool ownerHasWithdrawn;

    constructor() {
        startBlock = block.number;
        owner = payable(msg.sender);
        endBlock = startBlock + 90 / 15;
        bidIncrement = 10;
    }

    modifier onlyEnded {
        require(block.number > endBlock, "Auction has not ended yet");
        _;
    }

    modifier auctionRunning {
        require(block.number <= endBlock, "Auction has already ended");
        _;
    }

    modifier minBid {
        require(msg.value >= 1 ether, "Bid for at least 1 ETH");
        _;
    }

    modifier ownerNotAllowed {
        require(msg.sender != owner, "Owner cannot place a bid");
        _;
    }

    event LogBid(
        address bidder,
        uint256 bid,
        address highestBidder,
        uint256 highestBid,
        uint256 highestBindingBid
    );

    event LogHighestBid(address highestBidder, uint256 highestBid);

    event LogWithdrawal(address withdrawalAccount, uint256 withdrawalAmount);

    function placeBid() public payable ownerNotAllowed auctionRunning minBid {
        uint256 newBid = fundsByBidder[msg.sender] + msg.value;

        require(
            newBid > highestBindingBid,
            "Your bid must be greater than the highest bid"
        );

        uint256 highestBid = fundsByBidder[highestBidder];
        fundsByBidder[msg.sender] = newBid;

        if (newBid > highestBid) {
            if (msg.sender != highestBidder) {
                highestBidder = msg.sender;
                highestBindingBid = min(newBid, highestBid + bidIncrement);
            }
            highestBid = newBid;
        } else {
            highestBindingBid = min(newBid, highestBid + bidIncrement);
        }

        emit LogBid(
            msg.sender,
            newBid,
            highestBidder,
            highestBid,
            highestBindingBid
        );
    }

    function withdraw() public payable onlyEnded returns (bool) {
        address withdrawalAccount;
        uint256 withdrawalAmount;

        address payable sender = payable(msg.sender);

        if (sender == highestBidder) {
            withdrawalAccount = highestBidder;

            if (ownerHasWithdrawn) {
                withdrawalAmount = fundsByBidder[highestBidder];
            } else {
                withdrawalAmount =
                    fundsByBidder[highestBidder] -
                    highestBindingBid;
            }
        } else if (sender == owner) {
            withdrawalAccount = highestBidder;
            withdrawalAmount = highestBindingBid;
            ownerHasWithdrawn = true;
        } else {
            withdrawalAccount = msg.sender;
            withdrawalAmount = fundsByBidder[withdrawalAccount];
        }

        require(withdrawalAmount > 0, "You don't have anything to withdraw");
        fundsByBidder[withdrawalAccount] -= withdrawalAmount;

        if (!sender.send(withdrawalAmount)) {
            return false;
        }

        emit LogWithdrawal(withdrawalAccount, withdrawalAmount);

        return true;
    }

    function getHighestBidAndBidder() public {
        emit LogHighestBid(highestBidder, fundsByBidder[highestBidder]);
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a <= b ? a : b;
    }

    function autionEndAfter() public view returns (uint256) {
        return (endBlock - startBlock) * 15;
    }
    
    function getCurrentBlock() public view returns (uint256) {
        return block.number;
    }
}
