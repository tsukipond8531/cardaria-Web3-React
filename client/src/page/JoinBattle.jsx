import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

import { useGlobalContext } from '../context';
import { CustomButton, PageHOC } from '../components';
import styles from '../styles';

const JoinBattle = () => {
  return (
    <div>JoinBattle</div>
  )
}

export default PageHOC(
    JoinBattle,
    <>Join <br /> a Battle</>,
    <>Join already existing battles</>,
  );