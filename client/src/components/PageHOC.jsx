import React from 'react';
import { useNavigate } from 'react-router-dom';

import Alert from './Alert';
import { useGlobalContext } from '../context';
import { logo, heroImg, hero2Img, cardariaLogo } from '../assets';
import styles from '../styles';

const PageHOC = (Component, title, description) => () => {
  const { showAlert } = useGlobalContext();
  const navigate = useNavigate();

  return (
    <div className={styles.hocContainer}>
      {showAlert?.status && <Alert type={showAlert.type} message={showAlert.message} />}

      <div className={styles.hocContentBox}>
        <img src={cardariaLogo} alt="logo" className={styles.hocLogo} onClick={() => navigate('/')} />

        <div className={styles.hocBodyWrapper}>
          <div className="flex flex-row w-full">
            <h1 className={`flex ${styles.headText} head-text`}>{title}</h1>
          </div>

          <p className={`${styles.normalText} my-10`}>{description}</p>

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