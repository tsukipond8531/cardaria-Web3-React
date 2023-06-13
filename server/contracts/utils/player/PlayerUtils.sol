// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "../../AvaxGods.sol";

library PlayerUtils {
    function isPlayer(AVAXGods contractInstance, address addr) public view returns (bool) {
        if (contractInstance.playerInfo(addr) == 0) {
            return false;
        } else {
            return true;
        }
    }

    function getPlayer(AVAXGods contractInstance, address addr) public view returns (AVAXGods.Player memory) {
        require(isPlayer(contractInstance, addr), "Player doesn't exist!");
        return contractInstance.players(contractInstance.playerInfo(addr));
    }

    function getAllPlayers(AVAXGods contractInstance) public view returns (AVAXGods.Player[] memory) {
        return contractInstance.players();
    }

    function isPlayerToken(AVAXGods contractInstance, address addr) public view returns (bool) {
        if (contractInstance.playerTokenInfo(addr) == 0) {
            return false;
        } else {
            return true;
        }
    }
    function getPlayerToken(AVAXGods contractInstance, address addr) public view returns (AVAXGods.GameToken memory) {
        require(isPlayerToken(contractInstance, addr), "Game token doesn't exist!");
        return contractInstance.gameTokens(contractInstance.playerTokenInfo(addr));
    }

    function getAllPlayerTokens(AVAXGods contractInstance) public view returns (AVAXGods.GameToken[] memory) {
        return contractInstance.gameTokens();
    }
}
