// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "../../../helper/Helper.sol";
import "../../player/PlayerUtils.sol";

library CreateBattle {
    using Helper for *;
    using PlayerUtils for *;

    struct Battle {
        Helper.BattleStatus battleStatus;
        bytes32 battleHash;
        string name;
        address[2] players;
        uint8[2] moves;
        address winner;
    }

    function createBattle(string memory _name) internal returns (Battle memory) {
        require(isPlayer(msg.sender), "Please Register Player First");
        require(isBattle(_name), "Battle already exists!");

        bytes32 battleHash = keccak256(abi.encode(_name));

        Battle memory _battle = Battle(
            Helper.BattleStatus.PENDING,
            battleHash,
            _name,
            [msg.sender, address(0)],
            [0, 0],
            address(0)
        );

        uint256 _id = Helper.battles.length;
        Helper.battleInfo[_name] = _id;
        Helper.battles.push(_battle);

        return _battle;
    }
}
