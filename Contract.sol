// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.19;

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string calldata _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string calldata _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string calldata _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
