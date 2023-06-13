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
            _awaitBattleResults(_battleName);
        }
    }

        // Awaits battle results
        function _awaitBattleResults(string memory _battleName) internal {
            Battle memory _battle = getBattle(_battleName);

            require(
            msg.sender == _battle.players[0] || msg.sender == _battle.players[1],
            "Only players in this battle can make a move"
            );

            require(
            _battle.moves[0] != 0 &&  _battle.moves[1] != 0,
            "Players still need to make a move"
            );

            _resolveBattle(_battle);
        }
    /// @dev Resolve battle function to determine winner and loser of battle
  /// @param _battle battle; battle to resolve
  function _resolveBattle(Battle memory _battle) internal {
    P memory p1 = P(
        playerInfo[_battle.players[0]],
        _battle.moves[0],
        getPlayer(_battle.players[0]).playerHealth,
        getPlayerToken(_battle.players[0]).attackStrength,
        getPlayerToken(_battle.players[0]).defenseStrength
    );

    P memory p2 = P(
        playerInfo[_battle.players[1]],
        _battle.moves[1],
        getPlayer(_battle.players[1]).playerHealth,
        getPlayerToken(_battle.players[1]).attackStrength,
        getPlayerToken(_battle.players[1]).defenseStrength
    );

    address[2] memory _damagedPlayers = [address(0), address(0)];
    
    if (p1.move == 1 && p2.move == 1) {
      if (p1.attack >= p2.health) {
        _endBattle(_battle.players[0], _battle);
      } else if (p2.attack >= p1.health) {
        _endBattle(_battle.players[1], _battle);
      } else {
        players[p1.index].playerHealth -= p2.attack;
        players[p2.index].playerHealth -= p1.attack;

        players[p1.index].playerMana -= 3;
        players[p2.index].playerMana -= 3;

        // Both player's health damaged
        _damagedPlayers = _battle.players;
      }
    } else if (p1.move == 1 && p2.move == 2) {
      uint256 PHAD = p2.health + p2.defense;
      if (p1.attack >= PHAD) {
        _endBattle(_battle.players[0], _battle);
      } else {
        uint256 healthAfterAttack;
        
        if(p2.defense > p1.attack) {
          healthAfterAttack = p2.health;
        } else {
          healthAfterAttack = PHAD - p1.attack;

          // Player 2 health damaged
          _damagedPlayers[0] = _battle.players[1];
        }

        players[p2.index].playerHealth = healthAfterAttack;

        players[p1.index].playerMana -= 3;
        players[p2.index].playerMana += 3;
      }
    } else if (p1.move == 2 && p2.move == 1) {
      uint256 PHAD = p1.health + p1.defense;
      if (p2.attack >= PHAD) {
        _endBattle(_battle.players[1], _battle);
      } else {
        uint256 healthAfterAttack;
        
        if(p1.defense > p2.attack) {
          healthAfterAttack = p1.health;
        } else {
          healthAfterAttack = PHAD - p2.attack;

          // Player 1 health damaged
          _damagedPlayers[0] = _battle.players[0];
        }

        players[p1.index].playerHealth = healthAfterAttack;

        players[p1.index].playerMana += 3;
        players[p2.index].playerMana -= 3;
      }
    } else if (p1.move == 2 && p2.move == 2) {
        players[p1.index].playerMana += 3;
        players[p2.index].playerMana += 3;
    }

    emit RoundEnded(
      _damagedPlayers
    );

    // Reset moves to 0
    _battle.moves[0] = 0;
    _battle.moves[1] = 0;
    updateBattle(_battle.name, _battle);

    // Reset random attack and defense strength
    uint256 _randomAttackStrengthPlayer1 = _createRandomNum(MAX_ATTACK_DEFEND_STRENGTH, _battle.players[0]);
    gameTokens[playerTokenInfo[_battle.players[0]]].attackStrength = _randomAttackStrengthPlayer1;
    gameTokens[playerTokenInfo[_battle.players[0]]].defenseStrength = MAX_ATTACK_DEFEND_STRENGTH - _randomAttackStrengthPlayer1;

    uint256 _randomAttackStrengthPlayer2 = _createRandomNum(MAX_ATTACK_DEFEND_STRENGTH, _battle.players[1]);
    gameTokens[playerTokenInfo[_battle.players[1]]].attackStrength = _randomAttackStrengthPlayer2;
    gameTokens[playerTokenInfo[_battle.players[1]]].defenseStrength = MAX_ATTACK_DEFEND_STRENGTH - _randomAttackStrengthPlayer2;   
  }
}
