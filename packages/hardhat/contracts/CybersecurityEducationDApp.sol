// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CybersecurityEducationDApp is Ownable {
    
    mapping(address => bool) public legitContracts; // Mapping to track legit contracts
    mapping(address => bool) public maliciousContracts; // Mapping to track malicious contracts
    mapping(address => uint256) public userPoints; // Mapping to track user points
    
    event ContractPicked(address indexed user, bool isLegit, uint256 points);
    
    function generateLegitContract(string memory name, string memory symbol) external onlyOwner {
        address newContractAddress = address(new LegitContract(name, symbol, msg.sender));
        legitContracts[newContractAddress] = true;
    }
    
    function generateMaliciousContract(string memory name, string memory symbol) external onlyOwner {
        address newContractAddress = address(new MaliciousContract(name, symbol, msg.sender));
        maliciousContracts[newContractAddress] = true;
    }
    
    function pickContract(address contractAddress) external {
        require(legitContracts[contractAddress] || maliciousContracts[contractAddress], "Contract does not exist");
        
        if (legitContracts[contractAddress]) {
            userPoints[msg.sender] += 1; // Reward user with 1 point for picking legit contract
        } else {
            // Optional: Define action for picking a malicious contract if needed
        }
        
        emit ContractPicked(msg.sender, legitContracts[contractAddress], userPoints[msg.sender]);
    }
}

contract LegitContract is ERC721, Ownable {
    constructor(string memory name, string memory symbol, address initialOwner)
        ERC721(name, symbol) {
        transferOwnership(initialOwner);
    }
}

contract MaliciousContract is ERC721, Ownable {
    constructor(string memory name, string memory symbol, address initialOwner)
        ERC721(name, symbol) {
        transferOwnership(initialOwner);
    }
}