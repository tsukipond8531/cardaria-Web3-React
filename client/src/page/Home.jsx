import React, { useState } from 'react';
import { CustomButton, CustomInput, PageHOC } from '../components';
import { useGlobalContext } from '../context';

const Home = () => {
  const {contract, walletAddress, setShowAlert} = useGlobalContext();
  const [playerName, setplayerName] = useState('')

  const handleClick = async ()=> {
    try {
      console.log({contract})
      // console.log(walletAddress)
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
      setShowAlert({
        status: true,
        type: 'failure',
        message: error.message
      })
      // alert(error);
      // console.log(error);
    }
  }

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