import React from 'react';
import { Loader2 } from 'lucide-react';

export interface LoadingStateProps {
  message?: string;
  className?: string;
}

export const LoadingState: React.FC<LoadingStateProps> = ({
  message = 'Loading supervisory telemetry...',
  className = '',
}) => {
  return (
    <div className={`flex flex-col items-center justify-center p-12 text-slate-500 gap-3 ${className}`}>
      <Loader2 className="w-7 h-7 animate-spin text-blue-600" />
      <span className="text-xs font-mono tracking-wider">{message}</span>
    </div>
  );
};

export default LoadingState;
