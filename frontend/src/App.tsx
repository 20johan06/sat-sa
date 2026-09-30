import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import QueryProvider from './providers/QueryProvider';
import { AuthProvider } from './context/AuthContext';
import AppRoutes from './routes/AppRoutes';

export const App: React.FC = () => {
  return (
    <QueryProvider>
      <AuthProvider>
        <BrowserRouter>
          <AppRoutes />
        </BrowserRouter>
      </AuthProvider>
    </QueryProvider>
  );
};

export default App;
