// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "../../../helper/Helper.sol";
import "../../../Cardaria.sol";

library EndBattle {
    using Helper for *;

    struct Battle {
        Helper.BattleStatus battleStatus;
        bytes32 battleHash;
        string name;
        address[2] players;
        uint8[2] moves;
        address winner;
    }

    function endBattle(Battle storage self, address battleEnder, Battle memory _battle) internal returns (Battle memory) {
        require(_battle.battleStatus != Helper.BattleStatus.ENDED, "Battle already ended"); // Require that battle has not ended

        _battle.battleStatus = Helper.BattleStatus.ENDED;
        _battle.winner = battleEnder;
        self.updateBattle(_battle.name, _battle);

        uint256 p1 = self.playerInfo[_battle.players[0]];
        uint256 p2 = self.playerInfo[_battle.players[1]];

        self.players[p1].inBattle = false;
        self.players[p1].playerHealth = 25;
        self.players[p1].playerMana = 10;

        self.players[p2].inBattle = false;
        self.players[p2].playerHealth = 25;
        self.players[p2].playerMana = 10;

        address _battleLoser = battleEnder == _battle.players[0] ? _battle.players[1] : _battle.players[0];

        emit BattleEnded(_battle.name, battleEnder, _battleLoser); // Emits BattleEnded event

        return _battle;
    }
}
