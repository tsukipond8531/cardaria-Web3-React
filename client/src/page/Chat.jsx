import React, { useRef, useState } from 'react';
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
  

const Chat = () => {
    const [user] = useAuthState(auth);

    return (
      <>
      <div className="App">
        <header>
          <h1>⚛️🔥💬</h1>
          <SignOut />
        </header>
  
        <section>
          {user ? <ChatRoom /> : <SignIn />}
        </section>
  
      </div>
      </>
    )
  }

function SignIn() {

    const signInWithGoogle = () => {
      const provider = new firebase.auth.GoogleAuthProvider();
      auth.signInWithPopup(provider);
    }
  
    return (
      <>
        <button className="sign-in" onClick={signInWithGoogle}>Sign in with Google</button>
        <p>Do not violate the community guidelines or you will be banned for life!</p>
      </>
    )
  
  }
  
  function SignOut() {
    return auth.currentUser && (
      <button className="sign-out" onClick={() => auth.signOut()}>Sign Out</button>
    )
  }
  
  function ChatRoom() {
    const dummy = useRef();
    const messagesRef = firestore.collection('messages');
    const query = messagesRef.orderBy('createdAt').limit(25);
  
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
  
    return (<>
      <main>
  
        {messages && messages.map(msg => <ChatMessage key={msg.id} message={msg} />)}
  
        <span ref={dummy}></span>
  
      </main>
  
      <form onSubmit={sendMessage}>
  
        <input value={formValue} onChange={(e) => setFormValue(e.target.value)} placeholder="say something nice" />
  
        <button type="submit" disabled={!formValue}>🕊️</button>
  
      </form>
    </>)
  }
  
  
  function ChatMessage(props) {
    const { text, uid, photoURL } = props.message;
  
    const messageClass = uid === auth.currentUser.uid ? 'sent' : 'received';
  
    return (
      <div className={`message ${messageClass}`}>
        <img src={photoURL || 'https://api.adorable.io/avatars/23/abott@adorable.png'} />
        <p>{text}</p>
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