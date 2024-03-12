// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract DeciVote {
  address public owner;

    constructor() {
        owner = msg.sender; // Set the owner as the sender of the contract
    }

    struct Poll {
        string question;
        string[] choices;
        bool isOpen;
        mapping(address => bool) hasVoted;
        mapping(uint => uint) votes;
    }

    Poll[] public polls;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can create polls.");
        _;
    }

    function createPoll(string memory _question, string[] memory _choices) public onlyOwner {
        Poll storage newPoll = polls.push();
        newPoll.question = _question;
        newPoll.choices = _choices;
        newPoll.isOpen = true;
    }

    function closePoll(uint _pollIndex) public onlyOwner {
        require(_pollIndex < polls.length, "Poll does not exist.");
        Poll storage poll = polls[_pollIndex];
        poll.isOpen = false;
    }

    function vote(uint _pollIndex, uint _choiceIndex) public {
        require(_pollIndex < polls.length, "Poll does not exist.");
        require(_choiceIndex < polls[_pollIndex].choices.length, "Invalid choice.");
        Poll storage poll = polls[_pollIndex];
        require(poll.isOpen, "This poll is closed.");
        require(!poll.hasVoted[msg.sender], "You have already voted in this poll.");
        poll.hasVoted[msg.sender] = true;
        poll.votes[_choiceIndex]++;
    }

    function getResults(uint _pollIndex) public view returns (uint[] memory) {
        require(_pollIndex < polls.length, "Poll does not exist.");
        Poll storage poll = polls[_pollIndex];
        uint[] memory results = new uint[](poll.choices.length);
        for(uint i = 0; i < poll.choices.length; i++) {
            results[i] = poll.votes[i];
        }
        return results;
    }

    function getPollQuestion(uint _pollIndex) public view returns (string memory) {
        require(_pollIndex < polls.length, "Poll does not exist.");
        return polls[_pollIndex].question;
    }
}
