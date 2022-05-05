// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.19;

// 1. 在这里导入
import "./ownable.sol";
// 2. 在这里继承:
contract ZombieFactory is Ownable {

    // 这里建立事件
    event NewZombie(uint zombieId, string name, uint dna);
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        // 冷却定时器，限制僵尸猎食的频率
        uint32 readyTime;
    }

    Zombie[] public zombies;
    // 记录僵尸拥有者地址
    mapping(uint => address) public zombieToOwner;
    // 记录某地址所拥有的僵尸的数量
    mapping(address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna));
        // 这里触发事件
        uint id = zombies.length -1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}