pragma solidity ^0.8.0;

import "../Battle.sol";

library JoinBattle {
    using Battle for *;

    function joinBattle(
        Battle.Battle[] storage battles,
        Battle.Player[] storage players,
        mapping(address => uint256) storage playerInfo,
        function (string memory) external view returns (Battle.Battle memory) getBattleFunc,
        function (string memory, Battle.Battle memory) internal updateBattleFunc,
        function (address) external view returns (Battle.Player memory) getPlayerFunc,
        function (address) external view returns (bool) isPlayerFunc
    ) internal returns (Battle.Battle memory) {
        string memory _name = "your_battle_name_here";

        Battle.Battle memory _battle = getBattleFunc(_name);

        require(_battle.battleStatus == Battle.BattleStatus.PENDING, "Battle already started!");
        require(_battle.players[0] != msg.sender, "Only player two can join a battle");
        require(!getPlayerFunc(msg.sender).inBattle, "Already in battle");

        _battle.battleStatus = Battle.BattleStatus.STARTED;
        _battle.players[1] = msg.sender;
        updateBattleFunc(_name, _battle);

        players[playerInfo[_battle.players[0]]].inBattle = true;
        players[playerInfo[_battle.players[1]]].inBattle = true;

        emit NewBattle(_battle.name, _battle.players[0], msg.sender);
        return _battle;
    }
}
