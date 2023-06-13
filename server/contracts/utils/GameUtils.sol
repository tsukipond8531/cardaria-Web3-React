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

}
