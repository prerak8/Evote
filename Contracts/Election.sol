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
        address candidateAddress;
        bool isExist;
    }
    
    mapping (address => Voter) public voterDetails;
    mapping (address => Candidate) public candidateDetails;
    
    address admin;
    
    uint startTime;
    uint regPeriod = 45 seconds;
    uint votingPeriod = 45 seconds;
    bool isSorted;
    address[] public CandidateList;
    
    
    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }
    
    modifier notVotedBefore(address vtr) {
        require(voterDetails[vtr].isExist == true ,"Voter is not registered");
        require(voterDetails[vtr].Voted == false, "Voter has already voted");
        _;
    }

    modifier isInRegPhase() {
        require(now <= startTime + regPeriod seconds && now > startTime, "You can't register right now");
        _;
    }
    
     modifier isInVotingPhase() {
        require(now <= startTime + regPeriod + votingPeriod && now > startTime + regPeriod seconds, "You can't vote right now");
        _;
    }
    
    modifier isInResultPhase() {
        require(now > startTime + regPeriod + votingPeriod, "Results are not yet decleared");
        _;
    }

    function Election() public {
        admin = msg.sender;
        startTime = now;
        isSorted = false;
    }
   
    function addVoter(address vtrAdd, Voter vtr) onlyAdmin isInRegPhase public {
        voterDetails[vtrAdd] = vtr;
    }
    
    function addCandidate(Candidate cnd) onlyAdmin  public {
        candidateDetails[cnd.candidateAddress] = cnd;
        CandidateList.push(cnd.candidateAddress);
    }
    
    function vote(address cndAdd) notVotedBefore(msg.sender) isInVotingPhase public {
        address vtr = msg.sender;
        if (candidateDetails[cndAdd].isExist == false) return ;
        voterDetails[vtr].Voted = true;
        candidateDetails[cndAdd].voteCount++;
    }
    
    
    function bubbleSort() {
        for (uint i = 0; i < CandidateList.length; i++) {
            for (uint j = 0; j + 1 < CandidateList.length; j++) {
                if (candidateDetails[CandidateList[j]].voteCount < candidateDetails[CandidateList[j+1]].voteCount) {
                    address temp = CandidateList[j];
                    CandidateList[j] = CandidateList[j+1];
                    CandidateList[j+1] = temp;
                }
            }
        }
    } 

    function declareResult() isInResultPhase returns(address[] memory) {
        if (isSorted == false) {
            bubbleSort();
            isSorted = true;
        }
        return CandidateList;
    }
}