import React from 'react';
import { useNavigate } from 'react-router-dom';

import CustomButton from './CustomButton';
import { useGlobalContext } from '../context';
import { player01, player02 } from '../assets';
import styles from '../styles';

const GameLoad = () => {
    const { walletAddress, contract, gameData, setErrorMessage, setShowAlert } = useGlobalContext();
    const navigate = useNavigate();

    const handleBattleExit = async () => {
      const battleName = gameData.activeBattle.name;
  
      try {
        console.log('exit', battleName)
        await contract.quitBattle(battleName, { gasLimit: 50000 });

        console.log('exit', battleName)
        console.log(`You're quitting the ${battleName}`)
        setShowAlert({ status: true, type: 'info', message: `You're quitting the ${battleName}` });
      } catch (error) {
        console.log(error)
        // setErrorMessage(error);
      }
    };
  

  return (
    <div className={`${styles.flexBetween} ${styles.gameLoadContainer}`}>
    <div className={styles.gameLoadBtnBox}>
      <CustomButton
        title="Choose Battleground"
        handleClick={() => navigate('/battleground')}
        restStyles="mt-6"
      />
    </div>
    <div className={styles.gameLoadBtnBox}>
      <CustomButton title="Exit Battle" handleClick={() => handleBattleExit()} restStyles="mt-6" />
    </div>

    <div className={`flex-1 ${styles.flexCenter} flex-col`}>
      <h1 className={`${styles.headText} text-center`}>
        Waiting for a <br /> worthy opponent...
      </h1>
      <p className={styles.gameLoadText}>
        Protip: while you're waiting, choose your preferred battleground
      </p>

      <div className={styles.gameLoadPlayersBox}>
        <div className={`${styles.flexCenter} flex-col`}>
          <img src={player01} className={styles.gameLoadPlayerImg} />
          <p className={styles.gameLoadPlayerText}>
            {walletAddress.slice(0, 30)}
          </p>
        </div>

        <h2 className={styles.gameLoadVS}>Vs</h2>

        <div className={`${styles.flexCenter} flex-col`}>
          <img src={player02} className={styles.gameLoadPlayerImg} />
          <p className={styles.gameLoadPlayerText}>??????????</p>
        </div>
      </div>

      <div className="mt-10">
        <p className={`${styles.infoText} text-center mb-5`}>OR</p>

        <CustomButton
          title="Join other battles"
          handleClick={() => navigate('/join-battle')}
        />
      </div>
    </div>
  </div>
  )
}

export default GameLoad