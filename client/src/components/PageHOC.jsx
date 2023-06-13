import React, { useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';

import Alert from './Alert';
import { useGlobalContext } from '../context';
import { hero2Img, cardariaLogo } from '../assets';
import styles from '../styles';
import { ChatRoom, SignOut, SignIn } from '../page/Chat';

import PropTypes from 'prop-types';

import firebase from 'firebase/compat/app'; 
import 'firebase/compat/firestore';
import 'firebase/compat/auth';   
import 'firebase/compat/analytics';    

import { useAuthState } from 'react-firebase-hooks/auth';
import { useCollectionData } from 'react-firebase-hooks/firestore';

firebase.initializeApp({
    apiKey: "AIzaSyCAjbQCoyLgGnNE_208n43AnBIwm8rVKrw",
    authDomain: "gamechat-18c1d.firebaseapp.com",
    projectId: "gamechat-18c1d",
    storageBucket: "gamechat-18c1d.appspot.com",
    messagingSenderId: "1042124522594",
    appId: "1:1042124522594:web:473dc22e3008439ff07d3b",
    measurementId: "G-0B538W5VT2"
  })
  
const auth = firebase.auth();
const firestore = firebase.firestore();
const analytics = firebase.analytics();

const PageHOC = (Component, title, description) => () => {
  const { showAlert } = useGlobalContext();
  const navigate = useNavigate();
  const [user] = useAuthState(auth);

  return (
    <div className={styles.hocContainer}>
      {showAlert?.status && <Alert type={showAlert.type} message={showAlert.message} />}

      <div className={styles.hocContentBox}>
        <img src={cardariaLogo} alt="logo" className={styles.hocLogo} onClick={() => navigate('/')} />

        <div className={styles.hocBodyWrapper}>
          <div className="flex w-full">
            <div className="flex flex-col w-full justify-center">
              <h1 className={`flex ${styles.headText} head-text`}>{title}</h1>
              <p className={`${styles.normalText} my-10`}>{description}</p>
            </div>
            <div className="flex  bg-[#282c34] items-center justify-center w-full rounded-lg transition duration-500 shadow-lg scale-90 hover:shadow-2xl hover:scale-100">
              <div className="flex w-full bg-[#282c34] rounded-lg max-h-[256px]">
              <div className="App flex max-h-[256px] w-full overflow-hidden rounded-lg">
                  <section className="flex flex-col justify-start h-full w-full">
                    <div className="flex w-full justify-center h-full">
                      {user ? <ChatRoom /> : <SignIn />}
                    </div>
                  </section>
                </div>
              </div>
            </div>
          </div>
          <Component />
        </div>

        <p className={styles.footerText}>ver 1.0.1 | <span className={`${styles.infoText}`}><a href="/dev"></a>Developer's Notes</span></p>
      </div>

      <div className="flex flex-1">
        <img src={hero2Img} alt="hero-img" className="w-full xl:h-full object-cover bg-rose-800" />
      </div>
    </div>
  );
};

export default PageHOC;