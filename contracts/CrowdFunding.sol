// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    mapping(address => uint256) public contributers;
    address public manager;
    uint256 public minContribution;
    uint256 public deadline;
    uint256 public target;
    uint256 public raisedAmount;
    uint256 public numberOfContributers;

    struct Request {
        string description;
        address payable recepient;
        uint256 value;
        bool completed;
        uint256 numberOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;
    uint256 public numberOfRequests;

    constructor(uint256 _target, uint256 _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline;
        minContribution = 1 ether;
        manager = msg.sender;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline has passed!");
        _;
    }

    modifier afterDeadline() {
        require(block.timestamp > deadline, "Deadline has not passed yet!");
        _;
    }

    modifier minContributionPayed() {
        require(
            msg.value > minContribution,
            "Minimum contribution is not payed!"
        );
        _;
    }

    modifier targetNotMet() {
        require(target >= raisedAmount, "Target has been achieved!");
        _;
    }

    modifier targetMet() {
        require(target <= raisedAmount, "Target has not been achieved!");
        _;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can do this!");
        _;
    }

    modifier onlyContributer() {
        require(
            contributers[msg.sender] > 0,
            "You have not contributed anything!"
        );
        _;
    }

    function sendEth() public payable beforeDeadline minContributionPayed {
        if (contributers[msg.sender] == 0) {
            numberOfContributers++;
        }

        contributers[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function refund() public afterDeadline targetNotMet returns (bytes memory) {
        require(
            contributers[msg.sender] > 0,
            "You have not contributed anything!"
        );

        address payable user = payable(msg.sender);

        (bool sent, bytes memory data) = user.call{
            value: contributers[msg.sender]
        }("");
        require(sent, "Failed to refund!");

        contributers[msg.sender] = 0;
        return data;
    }

    function createRequest(
        string memory _description,
        address payable _recepient,
        uint256 _value
    ) public onlyManager {
        Request storage newRequest = requests[numberOfRequests];
        numberOfRequests++;
        newRequest.description = _description;
        newRequest.recepient = _recepient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.numberOfVoters = 0;
    }

    function voteRequest(uint256 _requestNo) public onlyContributer {
        Request storage thisRequest = requests[_requestNo];
        require(
            thisRequest.voters[msg.sender] == false,
            "You have already voted!"
        );
        thisRequest.voters[msg.sender] = true;
        thisRequest.numberOfVoters++;
    }

    function makePayment(uint256 _requestNo) public onlyManager targetMet returns(bytes memory) {
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "Request has been completed");
        require(
            thisRequest.numberOfVoters > numberOfContributers / 2,
            "Majority does not support!"
        );
        (bool sent, bytes memory data) = thisRequest.recepient.call{value: thisRequest.value}("");
        require(sent, "Failed to make payment!");
        return data;
    }
}
