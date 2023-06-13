import React, { useEffect, useState } from 'react';
import { CustomButton, CustomInput, PageHOC } from '../components';
import { useGlobalContext } from '../context';
import { useNavigate } from 'react-router-dom';

const Home = () => {
  const {contract, gameData, walletAddress, setShowAlert, setErrorMessage} = useGlobalContext();
  const [playerName, setplayerName] = useState('')
  const navigate = useNavigate();

  const handleClick = async ()=> {
    try {
      // console.log({contract})
      const playerExists = await contract.isPlayer(walletAddress);

      if(!playerExists) {
        // await contract.registerPlayer(playerName, playerName, { gasLimit: 500000 });
        await contract.registerPlayer(playerName, playerName);

        setShowAlert({
          status: true,
          type: 'info',
          message: `${playerName} is being summoned`
        })
      }
    } catch (error) {
      setErrorMessage(error);
      // alert(error);
      // console.log(error);
    }
  }

  useEffect(() => {
    const checkForPlayerToken = async () => {
      const playerExists = await contract.isPlayer(walletAddress);
      const playerTokenExists = await contract.isPlayerToken(walletAddress);

      // console.log({playerExists, playerTokenExists })

      if (playerExists && playerTokenExists) navigate('/create-battle');
    };

    if (contract) checkForPlayerToken();
  }, [contract]);

  useEffect(() => {
    if (gameData.activeBattle) {
      navigate(`/battle/${gameData.activeBattle.name}`);
    }
  }, [gameData]);

  return (
    <div className='flex flex-col'>
      <CustomInput
        label="Name"
        placeholder="Enter your player name"
        value={playerName}
        handleValueChange={setplayerName}
      />
      <CustomButton
        title="Register"
        handleClick={handleClick}
        restStyles="mt-6"
      />
    </div>
  )
};


export default PageHOC(
  Home,
  <>
    Welcome to Avax Gods <br /> a Web3 NFT Card Game
  </>,
  <>
    Connect your wallet to start playing <br /> the ultimate Web3 Battle Card
    Game
  </>,
);