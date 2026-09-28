import React from 'react';
import { AlertOctagon, RotateCw } from 'lucide-react';
import Button from './Button';

export interface ErrorStateProps {
  title?: string;
  message?: string;
  code?: string;
  onRetry?: () => void;
  className?: string;
}

export const ErrorState: React.FC<ErrorStateProps> = ({
  title = 'System Exception Encountered',
  message = 'Failed to load supervisory data from backend API.',
  code,
  onRetry,
  className = '',
}) => {
  return (
    <div className={`flex flex-col items-center justify-center text-center p-8 border border-red-200 rounded-lg bg-red-50/60 my-4 ${className}`}>
      <div className="p-3 rounded-full bg-white border border-red-200 text-red-600 shadow-xs mb-3">
        <AlertOctagon className="w-8 h-8" />
      </div>
      <h3 className="text-sm font-semibold text-red-900">{title}</h3>
      <p className="text-xs text-red-700/80 max-w-md mt-1 leading-relaxed">{message}</p>
      {code && (
        <span className="mt-2 text-[10px] font-mono px-2 py-0.5 rounded bg-red-100 border border-red-300 text-red-800">
          ERROR_CODE: {code}
        </span>
      )}
      {onRetry && (
        <div className="mt-4">
          <Button variant="danger" size="sm" icon={<RotateCw className="w-3.5 h-3.5" />} onClick={onRetry}>
            Retry Request
          </Button>
        </div>
      )}
    </div>
  );
};

export default ErrorState;
