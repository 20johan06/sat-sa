import React from 'react';

export const App: React.FC = () => {
  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 flex flex-col justify-between font-sans">
      {/* Header */}
      <header className="border-b border-slate-800 bg-slate-950/60 px-6 py-4 backdrop-blur">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="h-8 w-8 rounded-lg bg-blue-600 flex items-center justify-center font-bold text-white shadow-md">
              SA
            </div>
            <div>
              <h1 className="text-lg font-semibold tracking-tight text-white">SAT-SA</h1>
              <p className="text-xs text-slate-400">Supervisory Analytics Tool for SOC Assessment</p>
            </div>
          </div>
          <div className="flex items-center space-x-2">
            <span className="inline-flex items-center rounded-full bg-emerald-500/10 px-2.5 py-0.5 text-xs font-medium text-emerald-400 border border-emerald-500/20">
              Phase 1 Foundation
            </span>
            <span className="inline-flex items-center rounded-full bg-blue-500/10 px-2.5 py-0.5 text-xs font-medium text-blue-400 border border-blue-500/20">
              SIH 2026 PS 26157
            </span>
          </div>
        </div>
      </header>

      {/* Main Content Area Shell */}
      <main className="flex-1 max-w-7xl w-full mx-auto p-6 flex flex-col items-center justify-center text-center">
        <div className="max-w-xl p-8 rounded-2xl bg-slate-800/40 border border-slate-800 shadow-xl backdrop-blur-sm">
          <div className="inline-flex p-3 rounded-xl bg-blue-600/10 text-blue-400 border border-blue-500/20 mb-4">
            <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
            </svg>
          </div>
          <h2 className="text-xl font-medium text-white mb-2">Project Foundation Initialized</h2>
          <p className="text-sm text-slate-400 leading-relaxed mb-6">
            The technical shell for SAT-SA is configured with React, TypeScript, Vite, and Tailwind CSS. Business components and supervisory analytics tools will be integrated in subsequent development phases.
          </p>
          <div className="pt-4 border-t border-slate-800/80 flex items-center justify-center space-x-6 text-xs text-slate-400">
            <div className="flex items-center space-x-2">
              <span className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse"></span>
              <span>Backend API Ready</span>
            </div>
            <div className="flex items-center space-x-2">
              <span className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse"></span>
              <span>PostgreSQL Container Active</span>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-800 bg-slate-950/40 py-4 px-6 text-center text-xs text-slate-400">
        SAT-SA — SIH 2026 Problem Statement 26157 | supervisory Analytics Tool for SOC Assessment
      </footer>
    </div>
  );
};

export default App;
