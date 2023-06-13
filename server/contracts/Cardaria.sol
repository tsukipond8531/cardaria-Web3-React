pragma solidity ^0.8.0;

// import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
// import '@openzeppelin/contracts/access/Ownable.sol';
// import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol';

import "./helper/Helper.sol";
// import "./GameToken.sol";
import "./utils/player/PlayerUtils.sol";
// import "./Battle.sol";

contract Cardaria is ERC1155, Ownable, ERC1155Supply {
    string public baseURI; // baseURI where token metadata is stored
    uint256 public totalSupply; // Total number of tokens minted

    using Helper for *;

    mapping(address => uint256) public playerInfo;
    mapping(address => uint256) public playerTokenInfo;
    mapping(string => uint256) public battleInfo;

    Helper.Player[] public players;
    Helper.GameToken[] public gameTokens;
    Helper.Battle[] public battles;

    function isPlayer(address addr) public view returns (bool) {
        return PlayerUtils.isPlayer(this, addr);
    }

    function getPlayer(address addr) public view returns (Player memory) {
        return PlayerUtils.getPlayer(this, addr);
    }

    function getAllPlayers() public view returns (Player[] memory) {
        return PlayerUtils.getAllPlayers(this);
    }

    function isPlayerToken(address addr) public view returns (bool) {
        return PlayerUtils.isPlayerToken(this, addr);
    }

    function getPlayerToken(address addr) public view returns (AVAXGods.GameToken memory) {
        require(PlayerUtils.isPlayerToken(this, addr), "Game token doesn't exist!");
        return PlayerUtils.getPlayerToken(this, addr);
    }

    function getAllPlayerTokens() public view returns (AVAXGods.GameToken[] memory) {
        return PlayerUtils.getAllPlayerTokens(this);
    }

    // Rest of the contract code...
}