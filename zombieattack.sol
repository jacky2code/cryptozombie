// SPDX-License-Identifier: MIT
pragma solidity >=0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encode(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
}