import React from 'react'
import { PageHOC } from '../components';

const withChatBox = false; 

const DeveloperNotes = () => {
  return (
    <>
    </>
  )
}

export default PageHOC(
    DeveloperNotes,
    <>
      Coming Soon...
    </>,
    <>
    </>,
    withChatBox
  );