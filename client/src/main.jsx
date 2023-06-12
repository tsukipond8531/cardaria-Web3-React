import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Route, Routes } from 'react-router-dom';

import { Home, CreateBattle, JoinBattle } from './page';
import { GlobalContextProvider } from './context';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')).render(
  <BrowserRouter>
    <GlobalContextProvider>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/create-battle" element={<CreateBattle />} />
        <Route path="/join-battle" element={<JoinBattle />} />
      </Routes>
    </GlobalContextProvider>
  </BrowserRouter>,
);
