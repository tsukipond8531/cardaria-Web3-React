import React from 'react';
import { PageHOC } from '../components';
import { useGlobalContext } from '../context';

const Home = () => {
  const {demo} = useGlobalContext();

  return (
    <div>
      <h1 className="text-xl text-white">{demo}</h1>
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