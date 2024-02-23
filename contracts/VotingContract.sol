// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VotingFactory {

    // Array to store addresses of all created polls
    address[] public polls;

    // Function to create a new poll
    function createPoll(string memory _question, string[] memory _options) external {

        address newPoll = address(new Poll(_question, _options, msg.sender));
        
        polls.push(newPoll);
    }

    // Function to get all the polls created
    function getPolls() external view returns (address[] memory) {
        return polls;
    }
}


contract Poll {
    struct Voter {
        bool voted;       // Flag indicating if the voter has voted
        uint256 voteIndex; // Index of the option the voter voted for
    }

    // Struct to represent an option in the poll
    struct Option {
        string name;      // Name of the option
        uint256 voteCount; // Number of votes received for the option
    }

    // Question of the poll
    string public question;

    Option[] public options;
    // Mapping to keep track of voters and their votes
    mapping(address => Voter) public voters;

    
    constructor(string memory _question, string[] memory _options, address creator) {
        
        question = _question;
        // Adds options to the poll
        for (uint256 i = 0; i < _options.length; i++) {
            options.push(Option({name: _options[i], voteCount: 0}));
        }
        // Marks the creator as voted
        voters[creator].voted = true;
    }

    function vote(uint256 _option) external {
        require(!voters[msg.sender].voted, "You have already voted.");
        require(_option < options.length, "Invalid option.");
        
        // Marks the voter as voted and records the vote
        voters[msg.sender].voted = true;
        voters[msg.sender].voteIndex = _option;

        options[_option].voteCount++;
    }

    function getOptionsCount() external view returns (uint256) {
        
        return options.length;
    }

    function getOption(uint256 _index) external view returns (string memory name, uint256 voteCount) {
        require(_index < options.length, "Invalid option index.");
        
        name = options[_index].name;
        voteCount = options[_index].voteCount;
    }
}
