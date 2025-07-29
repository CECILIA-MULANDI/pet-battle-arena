// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PetBattleArena is ERC721, Ownable {
    uint256 private _petIdCounter;
    
    enum PetType { Fire, Water, Earth, Air, Lightning }
    
    struct Pet {
        string name;
        PetType petType;
        uint256 attack;
        uint256 defense;
        uint256 speed;
        uint256 health;
        uint256 experience;
        uint256 level;
        bool isAlive;
    }
    
    mapping(uint256 => Pet) public pets;
    mapping(address => uint256[]) public ownerPets;
    mapping(address => uint256) public creatorPets;
    
    event PetBorn(uint256 indexed petId, string name, PetType petType, address indexed creator);
    event BattleResult(uint256 indexed winner, uint256 indexed loser, uint256 expGained);
    event PetLevelUp(uint256 indexed petId, uint256 newLevel);
    
    constructor() ERC721("BattlePet", "BPET") Ownable(msg.sender) {}
    
    function createPet(string memory _name, PetType _petType) public returns (uint256) {
        uint256 petId = _petIdCounter++;
        
        pets[petId] = Pet({
            name: _name,
            petType: _petType,
            attack: _generateRandomStat(20, 50),
            defense: _generateRandomStat(15, 40),
            speed: _generateRandomStat(10, 30),
            health: 100,
            experience: 0,
            level: 1,
            isAlive: true
        });
        
        _safeMint(msg.sender, petId);
        ownerPets[msg.sender].push(petId);
        creatorPets[msg.sender]++;
        
        emit PetBorn(petId, _name, _petType, msg.sender);
        return petId;
    }
    
    function _generateRandomStat(uint256 min, uint256 max) private view returns (uint256) {
        return min + (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _petIdCounter))) % (max - min + 1));
    }
    
    function getPetsByOwner(address owner) public view returns (uint256[] memory) {
        return ownerPets[owner];
    }
}

    function battle(uint256 attackerId, uint256 defenderId) public returns (bool) {
        require(ownerOf(attackerId) == msg.sender, 'Not your pet!');
        require(pets[attackerId].isAlive && pets[defenderId].isAlive, 'Dead pets cannot battle!');
        
        Pet storage attacker = pets[attackerId];
        Pet storage defender = pets[defenderId];
        
        uint256 damage = calculateDamage(attacker, defender);
        
        if (defender.health <= damage) {
            defender.isAlive = false;
            attacker.experience += 50;
            emit BattleResult(attackerId, defenderId, 50);
            return true;
        } else {
            defender.health -= damage;
            attacker.experience += 10;
            return false;
        }
    }
// Bug fix: 6
// Rare pets: 7
