pragma experimental ABIEncoderV2;
pragma solidity ^0.4.0;

contract Election {
    
    struct Voter {
        bool Voted;
        bool isExist;
    }
    
    struct Candidate {
        string name;
        uint256 voteCount;
        bool isExist;
    }
    
    mapping (address => Voter) public voterDetails;
    mapping (address => Candidate) public candidateDetails;
    
    address admin;
    
    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }
    
    modifier notVotedBefore(address vtr) {
        require(voterDetails[vtr].isExist == true ,"Voter is not registered");
        require(voterDetails[vtr].Voted == false, "Voter has already voted");
        _;
    }

    function Election() public {
        admin = msg.sender;
    }
   
    function addVoter(address vtrAdd, Voter vtr) onlyAdmin public {
        voterDetails[vtrAdd] = vtr;
    }
    
    function addCandidate(address cndAdd, Candidate cnd) onlyAdmin public {
        candidateDetails[cndAdd] = cnd;
    }
    
    function vote(address cndAdd) notVotedBefore(msg.sender) public {
        address vtr = msg.sender;
        if (candidateDetails[cndAdd].isExist == false) return ;
        voterDetails[vtr].Voted = true;
        candidateDetails[cndAdd].voteCount++;
    }
}