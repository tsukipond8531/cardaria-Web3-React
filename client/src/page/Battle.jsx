import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import styles from '../styles';
import { Alert } from '../components';
import { useGlobalContext } from '../context';
import { attack, attackSound, defense, defenseSound, player01 as player01Icon, player02 as player02Icon } from '../assets';
import { playAudio } from '../utils/animation.js';

const Battle = () => {
    const { contract, gameData, walletAddress, showAlert, setShowAlert, battleGround } = useGlobalContext();
    const [player2, setPlayer2] = useState({});
    const [player1, setPlayer1] = useState({});
    const { battleName } = useParams();

    const navigate = useNavigate();
    console.log('p1',player1)
    console.log('p1',player2)

    useEffect(() => {
        const getPlayerInfo = async () => {
          try {
            let player01Address = null;
            let player02Address = null;
    
            if (gameData.activeBattle.players[0].toLowerCase() === walletAddress.toLowerCase()) {
              player01Address = gameData.activeBattle.players[0];
              player02Address = gameData.activeBattle.players[1];
            } else {
              player01Address = gameData.activeBattle.players[1];
              player02Address = gameData.activeBattle.players[0];
            }
    
            const p1TokenData = await contract.getPlayerToken(player01Address);
            const player01 = await contract.getPlayer(player01Address);
            const player02 = await contract.getPlayer(player02Address);
    
            const p1Att = p1TokenData.attackStrength.toNumber();
            const p1Def = p1TokenData.defenseStrength.toNumber();
            const p1H = player01.playerHealth.toNumber();
            const p1M = player01.playerMana.toNumber();
            const p2H = player02.playerHealth.toNumber();
            const p2M = player02.playerMana.toNumber();
    
            setPlayer1({ ...player01, att: p1Att, def: p1Def, health: p1H, mana: p1M });
            setPlayer2({ ...player02, att: 'X', def: 'X', health: p2H, mana: p2M });
          } catch (error) {
            console.log(error);
            // setErrorMessage(error.message);
          }
        };
    
        if (contract && gameData.activeBattle) getPlayerInfo();
      }, [contract, gameData, battleName]);

      console.log({contract, gameData, battleName})

  return (
    <div className={`${styles.flexBetween} ${styles.gameContainer} ${battleGround}`}>
        {showAlert?.status && <Alert type={showAlert.type} message={showAlert.message} />}

        <h1 className='text-xl text-black'>{battleName}</h1>
    </div>
  )
}

export default Battle