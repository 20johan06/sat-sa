import React, { createContext, useContext, useState, useEffect } from 'react';
import apiClient, { TOKEN_STORAGE_KEY } from '../api/client';

export interface UserProfile {
  id: string;
  username: string;
  email: string;
  full_name?: string;
  role: 'ADMIN' | 'SUPERVISOR' | 'VIEWER';
  is_active: boolean;
  allowed_cse_ids: string[];
  created_at: string;
  last_login_at?: string;
}

interface AuthContextType {
  user: UserProfile | null;
  token: string | null;
  isLoading: boolean;
  login: (token: string, user: UserProfile, rememberMe?: boolean) => void;
  logout: () => void;
  hasRole: (...roles: Array<'ADMIN' | 'SUPERVISOR' | 'VIEWER'>) => boolean;
  canAccessCSE: (cseId?: string) => boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [token, setToken] = useState<string | null>(() => {
    return sessionStorage.getItem(TOKEN_STORAGE_KEY) || localStorage.getItem(TOKEN_STORAGE_KEY);
  });
  const [user, setUser] = useState<UserProfile | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);

  useEffect(() => {
    const initAuth = async () => {
      const storedToken = sessionStorage.getItem(TOKEN_STORAGE_KEY) || localStorage.getItem(TOKEN_STORAGE_KEY);
      if (!storedToken) {
        setIsLoading(false);
        return;
      }

      try {
        const response = await apiClient.get<UserProfile>('/api/v1/auth/me');
        setUser(response.data);
        setToken(storedToken);
      } catch {
        sessionStorage.removeItem(TOKEN_STORAGE_KEY);
        localStorage.removeItem(TOKEN_STORAGE_KEY);
        setToken(null);
        setUser(null);
      } finally {
        setIsLoading(false);
      }
    };

    initAuth();
  }, []);

  const login = (newToken: string, newUser: UserProfile, rememberMe: boolean = false) => {
    if (rememberMe) {
      localStorage.setItem(TOKEN_STORAGE_KEY, newToken);
      sessionStorage.removeItem(TOKEN_STORAGE_KEY);
    } else {
      sessionStorage.setItem(TOKEN_STORAGE_KEY, newToken);
      localStorage.removeItem(TOKEN_STORAGE_KEY);
    }
    setToken(newToken);
    setUser(newUser);
  };

  const logout = async () => {
    try {
      if (token) {
        await apiClient.post('/api/v1/auth/logout');
      }
    } catch {
      // Ignore logout request network errors
    } finally {
      sessionStorage.removeItem(TOKEN_STORAGE_KEY);
      localStorage.removeItem(TOKEN_STORAGE_KEY);
      setToken(null);
      setUser(null);
    }
  };

  const hasRole = (...roles: Array<'ADMIN' | 'SUPERVISOR' | 'VIEWER'>): boolean => {
    if (!user) return false;
    return roles.includes(user.role);
  };

  const canAccessCSE = (cseId?: string): boolean => {
    if (!user) return false;
    if (user.role === 'ADMIN') return true;
    if (!cseId) return true;
    return user.allowed_cse_ids.includes(cseId);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        token,
        isLoading,
        login,
        logout,
        hasRole,
        canAccessCSE,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
