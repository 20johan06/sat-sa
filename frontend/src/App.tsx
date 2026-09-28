import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import QueryProvider from './providers/QueryProvider';
import AppRoutes from './routes/AppRoutes';

export const App: React.FC = () => {
  return (
    <QueryProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </QueryProvider>
  );
};

export default App;
