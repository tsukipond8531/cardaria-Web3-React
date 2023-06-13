// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "../../helper/Helper.sol";
import "./container/CreateBattle.sol";
import "./container/JoinBattle.sol";
import "./container/ReadBattleMoves.sol";
import "./container/EndBattle.sol";

library Battle {
    using Helper for *;
    using CreateBattle for *;
    using JoinBattle for *;
    using ReadBattleMoves for *;
    using EndBattle for *;

    struct Battle {
        BattleStatus battleStatus;
        bytes32 battleHash;
        string name;
        address[2] players;
        uint8[2] moves;
        address winner;
    }

    // Battle getter function
    function isBattle(Helper.Battle[] storage _battles, mapping(string => uint256) storage _battleInfo, string memory _name) internal view returns (bool) {
        if (_battleInfo[_name] == 0) {
            return false;
        } else {
            return true;
        }
    }

    function getBattle(Helper.Battle[] storage _battles, mapping(string => uint256) storage _battleInfo, string memory _name) internal view returns (Helper.Battle memory) {
        require(isBattle(_battles, _battleInfo, _name), "Battle doesn't exist!");
        return _battles[_battleInfo[_name]];
    }

    function getAllBattles(Helper.Battle[] storage _battles) internal view returns (Helper.Battle[] memory) {
        return _battles;
    }

    function updateBattle(Helper.Battle[] storage _battles, mapping(string => uint256) storage _battleInfo, string memory _name, Helper.Battle memory _newBattle) private {
        require(isBattle(_battles, _battleInfo, _name), "Battle doesn't exist");
        _battles[_battleInfo[_name]] = _newBattle;
    }

    /// @dev Creates a new battle
    /// @param _name battle name; set by player
    function createBattle(string memory _name) internal returns (CreateBattle.Battle memory) {
        return CreateBattle.createBattle(_name);
    }
    
    /// @dev Player joins battle
    /// @param _name battle name; name of battle player wants to join
    function joinBattle() internal returns (Battle memory) {
        return JoinBattle.joinBattle(battles, players, playerInfo, getBattle, updateBattle, getPlayer, isPlayer);
    }

    // Add other battle-related functions as needed
}
