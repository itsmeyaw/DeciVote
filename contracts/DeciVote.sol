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

    /** Create a poll, only owner can create a poll
     *
     * @param _question The question for the poll
     * @param _choices Available choices for this poll
     * @return the index of the poll
     */
    function createPoll(
        string memory _question,
        string[] memory _choices
    ) public onlyOwner returns (uint) {
        Poll storage newPoll = polls.push();
        newPoll.question = _question;
        newPoll.choices = _choices;
        newPoll.isOpen = true;
        return polls.length - 1;
    }

    /** Close a poll, only owner can close a poll
     *
     * @param _pollIndex The index of the poll
     */
    function closePoll(uint _pollIndex) public onlyOwner {
        require(_pollIndex < polls.length, "Poll does not exist.");
        Poll storage poll = polls[_pollIndex];
        poll.isOpen = false;
    }

    /** Cast a vote for a certain poll
     *
     * @param _pollIndex The index of the vote that want to be voted on
     * @param _choiceIndex The choice of the vote
     * @return The updated result of the poll
     */
    function vote(
        uint _pollIndex,
        uint _choiceIndex
    ) public returns (uint[] memory) {
        require(_pollIndex < polls.length, "Poll does not exist.");
        require(
            _choiceIndex < polls[_pollIndex].choices.length,
            "Invalid choice."
        );
        Poll storage poll = polls[_pollIndex];
        require(poll.isOpen, "This poll is closed.");
        require(
            !poll.hasVoted[msg.sender],
            "You have already voted in this poll."
        );
        poll.hasVoted[msg.sender] = true;
        poll.votes[_choiceIndex]++;
        uint[] memory results = new uint[](poll.choices.length);
        for (uint i = 0; i < poll.choices.length; i++) {
            results[i] = poll.votes[i];
        }
        return results;
    }

    /** Get the result of a poll
     *
     * @param _pollIndex The index of the poll that want to be queried
     * @return The result of the poll
     */
    function getResults(uint _pollIndex) public view returns (uint[] memory) {
        require(_pollIndex < polls.length, "Poll does not exist.");
        Poll storage poll = polls[_pollIndex];
        uint[] memory results = new uint[](poll.choices.length);
        for (uint i = 0; i < poll.choices.length; i++) {
            results[i] = poll.votes[i];
        }
        return results;
    }

    /** Get the question of a poll
     *
     * @param _pollIndex The index of the poll that want to be queried
     * @return The question of the poll
     */
    function getPollQuestion(
        uint _pollIndex
    ) public view returns (string memory) {
        require(_pollIndex < polls.length, "Poll does not exist.");
        return polls[_pollIndex].question;
    }
}
