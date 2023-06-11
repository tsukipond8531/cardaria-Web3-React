import React, { createContext, useContext, useEffect, useRef, useState } from 'react';
import { ethers } from 'ethers';
import Web3Modal from 'web3modal';
import { useNavigate } from 'react-router-dom';
import { ABI, ADDRESS } from '../contract';
import { createEventListeners } from './createEventListeners';

const GlobalContext = createContext();

export const GlobalContextProvider = ({children}) => {
    const [walletAddress, setWalletAddress] = useState('');
    const [contract, setContract] = useState(null);
    // const [connection, setConnection] = useState(null);
    // const [web3Modal, setWeb3Modal] = useState(null);
    const [provider, setProvider] = useState(null);
    const [showAlert, setShowAlert] = useState({ status: false, type: 'info', message: '' });


    const navigate = useNavigate();

    //* Set the wallet address to the state
    const updateCurrentWalletAddress = async () => {
      const accounts = await window?.ethereum?.request({ method: 'eth_accounts' });

      if (accounts) setWalletAddress(accounts[0]);
    };

    useEffect(() => {
      updateCurrentWalletAddress();

      window?.ethereum?.on('accountsChanged', updateCurrentWalletAddress);
    }, []);

    //* Set the smart contract and provider to the state
    useEffect(() => {
      const setSmartContractAndProvider = async () => {
        const web3Modal = new Web3Modal();
        const connection = await web3Modal.connect();
        // console.log("connection", connection); 
        const newProvider = new ethers.providers.Web3Provider(connection);
        const signer = newProvider.getSigner();
        const newContract = new ethers.Contract(ADDRESS, ABI, signer);

        setProvider(newProvider);
        setContract(newContract);
        setConnection(connection);
        setWeb3Modal(web3Modal);
      };

      setSmartContractAndProvider();
    }, []);

  //     if (contract) {
  //       console.log("contract", contract)
  //   console.log("connection", connection)
  //   console.log("web3modal", web3Modal)// Render a loading state while the contract is null
  // }

    //* Activate event listeners for the smart contract
    useEffect(() => {
      if (contract) {
        createEventListeners({
          navigate,
          contract,
          provider,
          walletAddress,
          setShowAlert,
          // player1Ref,
          // player2Ref,
          // setUpdateGameData,
        });
      }
    }, []);

    //* Handle alerts
    useEffect(() => {
      if (showAlert?.status) {
        const timer = setTimeout(() => {
          setShowAlert({ status: false, type: 'info', message: '' });
        }, [5000]);

        return () => clearTimeout(timer);
      }
    }, [showAlert]);

    return (
        <GlobalContext.Provider
          value={{
            contract,
            walletAddress,
            showAlert, 
            setShowAlert
          }}
        >
          {children}
        </GlobalContext.Provider>
    )
}

export const useGlobalContext = () => useContext(GlobalContext);