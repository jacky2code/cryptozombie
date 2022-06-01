// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        // 根据 Solidity 版本，做相应更新
        return
            uint256(
                keccak256(abi.encode(block.timestamp, msg.sender, randNonce))
            ) % _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId)
        external
        ownerOf(_zombieId)
    {
        // 我方僵尸
        Zombie storage myZombie = zombies[_zombieId];
        // 攻击目标僵尸
        Zombie storage enemyZombie = zombies[_targetId];
        // 随机数确定战斗结果
        uint256 rand = randMod(100);

        if (rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }
}
