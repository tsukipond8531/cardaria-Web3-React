// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

// import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
// import '@openzeppelin/contracts/access/Ownable.sol';
// import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol';

import "./helper/Helper.sol";
// import "./GameToken.sol";
import "./utils/player/PlayerUtils.sol";
import "./utils/battle/Battle.sol";
import "./utils/GameUtils.sol";

contract Cardaria is ERC1155, Ownable, ERC1155Supply {
    string public baseURI; // baseURI where token metadata is stored
    uint256 public totalSupply; // Total number of tokens minted

    using Helper for *;
    using Battle for *;

    mapping(address => uint256) public playerInfo;
    mapping(address => uint256) public playerTokenInfo;
    mapping(string => uint256) public battleInfo;

    Helper.Player[] public players;
    Helper.GameToken[] public gameTokens;
    Helper.Battle[] public battles;

    // Player Function
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

    // Battle getter function
    function isBattle(string memory _name) public view returns (bool) {
        return Battle.isBattle(battles, battleInfo, _name);
    }

    function getBattle(string memory _name) public view returns (Helper.Battle memory) {
        return Battle.getBattle(battles, battleInfo, _name);
    }

    function getAllBattles() public view returns (Helper.Battle[] memory) {
        return Battle.getAllBattles(battles);
    }

    function updateBattle(string memory _name, Helper.Battle memory _newBattle) private {  
        Battle.updateBattle(battles, battleInfo, _name, _newBattle);
    }

      // Events
    event NewPlayer(address indexed owner, string name);
    event NewBattle(string battleName, address indexed player1, address indexed player2);
    event BattleEnded(string battleName, address indexed winner, address indexed loser);
    event BattleMove(string indexed battleName, bool indexed isFirstMove);
    event NewGameToken(address indexed owner, uint256 id, uint256 attackStrength, uint256 defenseStrength);
    event RoundEnded(address[2] damagedPlayers);

    /// @dev Initializes the contract by setting a `metadataURI` to the token collection
    /// @param _metadataURI baseURI where token metadata is stored
    constructor(string memory _metadataURI) ERC1155(_metadataURI) {
        baseURI = _metadataURI; // Set baseURI
        initialize();
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function initialize() private {
        gameTokens.push(GameToken("", 0, 0, 0));
        players.push(Player(address(0), "", 0, 0, false));
        battles.push(Battle(BattleStatus.PENDING, bytes32(0), "", [address(0), address(0)], [0, 0], address(0)));
    }

    //registerPlayer
    function registerPlayer(string memory _name, string memory _gameTokenName) external {
        GameUtils.registerPlayer(this, _name, _gameTokenName);
    }

    function createRandomGameToken(string memory _name) public {
        GameUtils.createRandomGameToken(this, _name);
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply;
    }
    // Turns uint256 into string
    function uintToStr(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
        return '0';
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
        len++;
        j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
        k = k - 1;
        uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
        bytes1 b1 = bytes1(temp);
        bstr[k] = b1;
        _i /= 10;
        }
        return string(bstr);
    }

    // Token URI getter function
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return string(abi.encodePacked(baseURI, '/', uintToStr(tokenId), '.json'));
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
    // Rest of the contract code...
}