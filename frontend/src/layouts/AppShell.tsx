import React, { useState } from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import {
  Shield,
  Building2,
  Search,
  HeartPulse,
  Menu,
  X,
  ExternalLink,
  LogOut,
  UserCheck,
  FileCheck2
} from 'lucide-react';
import IconButton from '../components/ui/IconButton';
import { useAuth } from '../context/AuthContext';

export const AppShell: React.FC = () => {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const { user, logout, hasRole } = useAuth();

  // Primary top-level global navigation items
  const primaryNavItems = [
    { label: 'CSE Directory', path: '/', icon: <Building2 className="w-4 h-4" /> },
    { label: 'National Findings', path: '/findings', icon: <Search className="w-4 h-4" /> },
    { label: 'System Health', path: '/system/health', icon: <HeartPulse className="w-4 h-4" /> },
  ];

  if (hasRole('ADMIN', 'SUPERVISOR')) {
    primaryNavItems.push({
      label: 'Validation Engine',
      path: '/validation',
      icon: <FileCheck2 className="w-4 h-4" />
    });
  }

  return (
    <div className="min-h-screen bg-surface-bg text-slate-900 flex flex-col font-sans antialiased">
      {/* Top Authoritative Header Bar */}
      <header className="border-b border-header-border bg-header-bg text-white sticky top-0 z-40 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          {/* Logo & Platform Title */}
          <div className="flex items-center gap-3">
            <div className="h-9 w-9 rounded-md bg-blue-600 border border-blue-400/40 flex items-center justify-center font-bold text-white shadow-xs">
              <Shield className="w-5 h-5 text-white" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="text-base font-bold tracking-tight text-white font-mono">SAT-SA</span>
                <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-slate-800 border border-slate-700 text-blue-300 uppercase">
                  Supervisory Authority
                </span>
              </div>
              <p className="text-[11px] text-slate-400 hidden sm:block">
                Supervisory Analytics Tool for SOC Assessment
              </p>
            </div>
          </div>

          {/* User Profile Badge & Logout */}
          <div className="hidden md:flex items-center gap-4">
            {user ? (
              <div className="flex items-center gap-3 bg-slate-800/90 px-3.5 py-1.5 rounded-lg border border-slate-700">
                <div className="w-7 h-7 rounded-full bg-indigo-600/30 text-indigo-300 flex items-center justify-center border border-indigo-500/30">
                  <UserCheck className="w-4 h-4" />
                </div>
                <div className="flex flex-col text-left">
                  <div className="flex items-center gap-2">
                    <span className="text-xs font-semibold text-white font-mono">{user.username}</span>
                    <span className={`text-[10px] font-mono font-bold uppercase px-1.5 py-0.2 rounded border ${
                      user.role === 'ADMIN' ? 'bg-purple-900/60 text-purple-300 border-purple-700' :
                      user.role === 'SUPERVISOR' ? 'bg-blue-900/60 text-blue-300 border-blue-700' :
                      'bg-slate-700 text-slate-300 border-slate-600'
                    }`}>
                      {user.role}
                    </span>
                  </div>
                  <span className="text-[10px] text-slate-400">{user.email}</span>
                </div>
                <button
                  onClick={logout}
                  title="Sign Out"
                  className="ml-2 p-1.5 text-slate-400 hover:text-white hover:bg-slate-700 rounded-md transition-colors"
                >
                  <LogOut className="w-4 h-4" />
                </button>
              </div>
            ) : (
              <a
                href="/login"
                className="text-xs font-semibold px-3 py-1.5 rounded-md bg-blue-600 text-white hover:bg-blue-500 transition-colors"
              >
                Sign In
              </a>
            )}

            <a
              href="/system/health"
              className="text-xs text-slate-300 hover:text-white flex items-center gap-1 font-mono transition-colors"
            >
              <span>Health Status</span>
              <ExternalLink className="w-3 h-3" />
            </a>
          </div>

          {/* Mobile Menu Button */}
          <div className="md:hidden">
            <IconButton
              aria-label={mobileMenuOpen ? 'Close navigation menu' : 'Open navigation menu'}
              variant="header"
              icon={mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            />
          </div>
        </div>

        {/* Primary Desktop Navigation Bar */}
        <div className="hidden md:block border-t border-slate-800 bg-slate-900/90">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <nav aria-label="Primary Navigation" className="flex space-x-1 py-1">
              {primaryNavItems.map((item) => (
                <NavLink
                  key={item.path}
                  to={item.path}
                  end={item.path === '/'}
                  className={({ isActive }) => `
                    flex items-center gap-2 px-3.5 py-2 rounded-md text-xs font-semibold transition-colors whitespace-nowrap
                    ${isActive
                      ? 'bg-blue-600 text-white font-semibold shadow-xs'
                      : 'text-slate-300 hover:text-white hover:bg-slate-800'
                    }
                  `}
                >
                  {item.icon}
                  <span>{item.label}</span>
                </NavLink>
              ))}
            </nav>
          </div>
        </div>

        {/* Mobile Navigation Drawer */}
        {mobileMenuOpen && (
          <div className="md:hidden border-t border-slate-800 bg-slate-900 px-4 py-3 space-y-2">
            {user && (
              <div className="pb-3 mb-2 border-b border-slate-800 flex items-center justify-between">
                <div>
                  <p className="text-xs font-bold text-white font-mono">{user.username}</p>
                  <p className="text-[10px] text-slate-400">{user.role} Role</p>
                </div>
                <button
                  onClick={logout}
                  className="flex items-center gap-1 text-xs text-rose-400 hover:text-rose-300 font-medium"
                >
                  <LogOut className="w-3.5 h-3.5" /> Sign Out
                </button>
              </div>
            )}

            {primaryNavItems.map((item) => (
              <NavLink
                key={item.path}
                to={item.path}
                end={item.path === '/'}
                onClick={() => setMobileMenuOpen(false)}
                className={({ isActive }) => `
                  flex items-center gap-3 px-3 py-2.5 rounded-md text-sm font-medium transition-colors
                  ${isActive
                    ? 'bg-blue-600 text-white font-semibold'
                    : 'text-slate-300 hover:bg-slate-800'
                  }
                `}
              >
                {item.icon}
                <span>{item.label}</span>
              </NavLink>
            ))}
          </div>
        )}
      </header>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col">
        <Outlet />
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-200 bg-white py-4 px-6 text-center text-xs text-slate-500 font-mono">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-2">
          <span>SAT-SA — Supervisory Analytics Tool for SOC Assessment</span>
          <span>SIH 2026 Problem Statement 26157 | Phase 2 RBAC & Auth</span>
        </div>
      </footer>
    </div>
  );
};

export default AppShell;
