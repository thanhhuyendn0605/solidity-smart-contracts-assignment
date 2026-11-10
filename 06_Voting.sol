
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint256 voteIndex;
    }

    Candidate[] public candidates;
    mapping(address => Voter) public voters;
    address public chairperson;

    event VoterAuthorized(address indexed voter);
    event VoteCast(address indexed voter, uint256 candidateIndex);

    constructor(string[] memory candidateNames) {
        require(candidateNames.length > 0, "No candidates");

        chairperson = msg.sender;

        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
    }

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Not chairperson");
        _;
    }

    function authorize(address voter)
        external onlyChairperson
    {
        require(voter != address(0), "Invalid address");
        require(!voters[voter].authorized, "Already authorized");

        voters[voter].authorized = true;

        emit VoterAuthorized(voter);
    }

    function vote(uint256 candidateIndex) external {
        Voter storage sender = voters[msg.sender];

        require(sender.authorized, "Not authorized");
        require(!sender.voted, "Already voted");
        require(candidateIndex < candidates.length, "Invalid candidate");

        sender.voted = true;
        sender.voteIndex = candidateIndex;

        candidates[candidateIndex].voteCount++;

        emit VoteCast(msg.sender, candidateIndex);
    }

    function totalVotes(uint256 candidateIndex)
        external view returns (uint256)
    {
        require(candidateIndex < candidates.length, "Invalid candidate");
        return candidates[candidateIndex].voteCount;
    }

    function winnerName()
        external view returns (string memory)
    {
        uint256 winnerIndex = 0;

        for (uint256 i = 1; i < candidates.length; i++) {
            if (candidates[i].voteCount >
                candidates[winnerIndex].voteCount) {
                winnerIndex = i;
            }
        }

        return candidates[winnerIndex].name;
    }
}
