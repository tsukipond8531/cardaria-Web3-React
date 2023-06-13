import React, { useRef, useState } from 'react';
import PropTypes from 'prop-types';

import firebase from 'firebase/compat/app'; 
import 'firebase/compat/firestore';
import 'firebase/compat/auth';   
import 'firebase/compat/analytics';    

import '../styles/Chat.css'

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
  

const Chat = () => {
    const [user] = useAuthState(auth);

    return (
      <>
      <div className="App flex w-full h-[128px] max-h-[128px]">
        <header>
          <h1>⚛️🔥💬</h1>
          <SignOut />
        </header>
  
        <section className="flex w-full">
          {user ? <ChatRoom /> : <SignIn />}
        </section>
  
      </div>
      </>
    )
  }

export function SignIn() {

    const signInWithGoogle = () => {
      const provider = new firebase.auth.GoogleAuthProvider();
      auth.signInWithPopup(provider);
    }
  
    return (
      <div className="flex flex-col  w-full">
        <p className="text-white font-bold text-xl mt-16 mb-2">CARDARIA CHAT BOX</p>
        <button className="sign-in p-2 bg-blue-500 rounded text-white" onClick={signInWithGoogle}>Join Chat!</button>
        <p className="text-white">Do not violate the community guidelines or you will be banned for life!</p>
      </div>
    )
  
  }
  
export function SignOut() {
    return auth.currentUser && (
      <button className="sign-out bg-rose-800 p-1 rounded font-semibold" onClick={() => auth.signOut()}>Sign Out</button>
    )
  }
  
export  function ChatRoom() {
    const dummy = useRef();
    const messagesRef = firestore.collection('messages');
    const query = messagesRef.orderBy('createdAt');
  
    const [messages] = useCollectionData(query, { idField: 'id' });
  
    const [formValue, setFormValue] = useState('');
  
  
    const sendMessage = async (e) => {
      e.preventDefault();
  
      const { uid, photoURL } = auth.currentUser;
  
      await messagesRef.add({
        text: formValue,
        createdAt: firebase.firestore.FieldValue.serverTimestamp(),
        uid,
        photoURL
      })
  
      setFormValue('');
      dummy.current.scrollIntoView({ behavior: 'smooth' });
    }
  
    return (
    <>
    <div className="flex flex-col w-full rounded-lg">
        <div className="text-white flex justify-between mx-5">
            <p className="text-white font-semibold text-xl">Chat Box:</p>
            <SignOut />
        </div>
        <main className="chat-main flex w-full relative">
            {messages && messages.map(msg => <ChatMessage key={msg.id} message={msg} />)}
            <span ref={dummy}></span>
        </main>
        <div className="relative w-full">
            <form onSubmit={sendMessage} className="chat-form flex w-full fixed rounded-b-md">
                <input className='w-[384px] lg:[256px] text-blue-500 pl-2 rounded-bl-md  placeholder:text-xl'  value={formValue} onChange={(e) => setFormValue(e.target.value)} placeholder="do not trash talk..." />
                <button className="rounded-b-md bg-blue-500" type="submit" disabled={!formValue}>🕊️</button>
            </form>
        </div>
    </div>

    </>)
  }
  
  
  function ChatMessage(props) {
    const { text, uid, photoURL } = props.message;
  
    const messageClass = uid === auth.currentUser.uid ? 'sent' : 'received';
  
    return (
      <div className={`message ${messageClass} `}>
        <img src={photoURL || 'https://api.adorable.io/avatars/23/abott@adorable.png'} className='chat-img my-2 mx-5' />
        <p className='chat-p bg-blue-500'>{text}</p>
      </div>
    );
  }
  
  ChatMessage.propTypes = {
    message: PropTypes.shape({
      text: PropTypes.string.isRequired,
      uid: PropTypes.string.isRequired,
      photoURL: PropTypes.string,
    }).isRequired,
  };

export default Chat