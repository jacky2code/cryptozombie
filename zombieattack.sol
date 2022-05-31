// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        // 根据 Solidity 版本，做相应更新
        return uint(keccak256(abi.encode(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        // 我方僵尸
        Zombie storage myZombie = zombies[_zombieId];
        // 攻击目标僵尸
        Zombie storage enemyZombie = zombies[_targetId];
        // 随机数确定战斗结果
        uint rand = randMod(100);
    }
}