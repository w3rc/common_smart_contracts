// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address manager;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether, "Please pay 1 one ether");
        players.push(payable(msg.sender));
    }

    function getBalance() public view  returns (uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);
        winner = players[random() % players.length];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }

    function getAllPlayers()  public view returns (address payable[] memory) {
        return players;
    }
}