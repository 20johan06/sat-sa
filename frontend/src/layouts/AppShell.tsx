import React, { useState } from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import {
  Shield,
  Building2,
  Search,
  HeartPulse,
  Menu,
  X,
  ExternalLink
} from 'lucide-react';
import IconButton from '../components/ui/IconButton';

export const AppShell: React.FC = () => {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // Primary top-level global navigation items
  const primaryNavItems = [
    { label: 'CSE Directory', path: '/', icon: <Building2 className="w-4 h-4" /> },
    { label: 'National Findings', path: '/findings', icon: <Search className="w-4 h-4" /> },
    { label: 'System Health', path: '/system/health', icon: <HeartPulse className="w-4 h-4" /> },
  ];

  return (
    <div className="min-h-screen bg-surface-bg text-slate-900 flex flex-col font-sans antialiased">
      {/* Top Authoritative Header Bar (Dark Slate Navy header contrast) */}
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

          {/* Right Header Metadata & Health Link */}
          <div className="hidden md:flex items-center gap-4">
            <div className="flex items-center gap-2 text-xs font-mono text-slate-300 bg-slate-900/80 px-3 py-1.5 rounded-md border border-slate-800">
              <span className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
              <span>Backend API Ready</span>
            </div>
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
          <div className="md:hidden border-t border-slate-800 bg-slate-900 px-4 py-3 space-y-1">
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
          <span>SIH 2026 Problem Statement 26157 | Phase 2 Shell</span>
        </div>
      </footer>
    </div>
  );
};

export default AppShell;
