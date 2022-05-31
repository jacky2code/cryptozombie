// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    // 升级所需支付费用
    uint levelUpFee = 0.001 ether;

    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // 从合约中提现以太
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
    // 设置支付费用 
    function setLevelUpfee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // 支付eth，升级僵尸 
    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    // 修改僵尸名字
    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
        ownerOf(_zombieId)
    {
        zombies[_zombieId].name = _newName;
    }

    // 定制 DNA
    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
        ownerOf(_zombieId)
    {
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
