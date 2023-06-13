// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "../Cardaria.sol";

library GameUtils {
    using Cardaria for *;

    function registerPlayer(Cardaria contractInstance, string memory _name, string memory _gameTokenName) external {
        require(!contractInstance.isPlayer(msg.sender), "Player already registered");

        uint256 _id = contractInstance.players.length;
        contractInstance.players.push(Cardaria.Player(msg.sender, _name, 10, 25, false));
        contractInstance.playerInfo[msg.sender] = _id;

        contractInstance.createRandomGameToken(_gameTokenName);

        emit Cardaria.NewPlayer(msg.sender, _name);
    }

    function _createRandomNum(Cardaria contractInstance, uint256 _max, address _sender) internal view returns (uint256 randomValue) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _sender)));

        randomValue = randomNum % _max;
        if (randomValue == 0) {
            randomValue = _max / 2;
        }

        return randomValue;
    }

    function _createGameToken(Cardaria contractInstance, string memory _name) internal returns (Cardaria.GameToken memory) {
        uint256 randAttackStrength = _createRandomNum(contractInstance, Cardaria.MAX_ATTACK_DEFEND_STRENGTH, msg.sender);
        uint256 randDefenseStrength = Cardaria.MAX_ATTACK_DEFEND_STRENGTH - randAttackStrength;

        uint8 randId = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100);
        randId = randId % 6;
        if (randId == 0) {
            randId++;
        }

        Cardaria.GameToken memory newGameToken = Cardaria.GameToken(
            _name,
            randId,
            randAttackStrength,
            randDefenseStrength
        );

        uint256 _id = contractInstance.gameTokens.length;
        contractInstance.gameTokens.push(newGameToken);
        contractInstance.playerTokenInfo[msg.sender] = _id;

        contractInstance._mint(msg.sender, randId, 1, '0x0');
        contractInstance.totalSupply++;

        emit Cardaria.NewGameToken(msg.sender, randId, randAttackStrength, randDefenseStrength);
        return newGameToken;
    }

    function createRandomGameToken(Cardaria contractInstance, string memory _name) public {
        require(!contractInstance.getPlayer(msg.sender).inBattle, "Player is in a battle");
        require(contractInstance.isPlayer(msg.sender), "Please Register Player First");

        _createGameToken(contractInstance, _name);
    }

    function getTotalSupply(Cardaria contractInstance) external view returns (uint256) {
        return contractInstance.totalSupply;
    }
}
