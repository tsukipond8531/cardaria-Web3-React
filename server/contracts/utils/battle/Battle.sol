pragma solidity ^0.8.0;

import "../../helper/Helper.sol";
import "./container/CreateBattle.sol";

library Battle {
    using Helper for *;
    using CreateBattle for *;

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

    function createBattle(string memory _name) internal returns (CreateBattle.Battle memory) {
        return CreateBattle.createBattle(_name);
    }
    

    // Add other battle-related functions as needed
}
