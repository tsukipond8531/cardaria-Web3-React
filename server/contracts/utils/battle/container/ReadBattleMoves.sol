pragma solidity ^0.8.0;

import "../Battle.sol";

library ReadBattleMoves {
    using Battle for *;

    function getBattleMoves(Battle.Battle[] storage battles, function (string memory) external view returns (Battle.Battle memory) getBattleFunc, string memory _battleName) public view returns (uint256 P1Move, uint256 P2Move) {
        Battle.Battle memory _battle = getBattleFunc(_battleName);

        P1Move = _battle.moves[0];
        P2Move = _battle.moves[1];

        return (P1Move, P2Move);
    }

    function registerPlayerMove(Battle.Battle[] storage battles, mapping(string => uint256) storage battleInfo, function (string memory) external view returns (Battle.Battle memory) getBattleFunc, function (string memory, Battle.Battle memory) internal updateBattleFunc, Battle.Player[] storage players, mapping(address => uint256) storage playerInfo, uint256 _player, uint8 _choice, string memory _battleName) internal {
        require(_choice == 1 || _choice == 2, "Choice should be either 1 or 2!");
        require(_choice == 1 ? Battle.getPlayer(msg.sender).playerMana >= 3 : true, "Mana not sufficient for attacking!");
        battles[battleInfo[_battleName]].moves[_player] = _choice;
    }

    function attackOrDefendChoice(Battle.Battle[] storage battles, function (string memory) external view returns (Battle.Battle memory) getBattleFunc, function (string memory, Battle.Battle memory) internal updateBattleFunc, Battle.Player[] storage players, mapping(address => uint256) storage playerInfo, uint8 _choice, string memory _battleName) external {
        Battle.Battle memory _battle = getBattleFunc(_battleName);

        require(
            _battle.battleStatus == Battle.BattleStatus.STARTED,
            "Battle not started. Please tell another player to join the battle"
        ); // Require that battle has started
        require(
            _battle.battleStatus != Battle.BattleStatus.ENDED,
            "Battle has already ended"
        ); // Require that battle has not ended
        require(
            msg.sender == _battle.players[0] || msg.sender == _battle.players[1],
            "You are not in this battle"
        ); // Require that player is in the battle

        require(_battle.moves[_battle.players[0] == msg.sender ? 0 : 1] == 0, "You have already made a move!");

        registerPlayerMove(battles, battleInfo, getBattleFunc, updateBattleFunc, players, playerInfo, _battle.players[0] == msg.sender ? 0 : 1, _choice, _battleName);

        _battle = getBattleFunc(_battleName);
        uint _movesLeft = 2 - (_battle.moves[0] == 0 ? 0 : 1) - (_battle.moves[1] == 0 ? 0 : 1);
        emit BattleMove(_battleName, _movesLeft == 1 ? true : false);

        if (_movesLeft == 0) {
            // _awaitBattleResults(_battleName);
        }
    }
}
