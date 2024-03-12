# DeciVote

A simple voting smart contract written in Solidity.

## Contract ABI

### createPoll

Description: Create a new poll, only the owner of smart contract can create poll

Inputs:

- \_question (string): The question for the poll
- \_choices (string[]): The options for the poll
