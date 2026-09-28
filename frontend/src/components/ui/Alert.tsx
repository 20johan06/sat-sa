import React from 'react';
import { AlertCircle, AlertTriangle, CheckCircle2, Info, X } from 'lucide-react';

export interface AlertProps {
  type?: 'info' | 'warning' | 'error' | 'success';
  title?: string;
  children: React.ReactNode;
  onClose?: () => void;
  className?: string;
}

export const Alert: React.FC<AlertProps> = ({
  type = 'info',
  title,
  children,
  onClose,
  className = '',
}) => {
  const typeStyles = {
    info: {
      container: 'bg-sky-50 border-sky-200 text-sky-900',
      icon: <Info className="w-4 h-4 text-sky-600 shrink-0 mt-0.5" />,
    },
    warning: {
      container: 'bg-amber-50 border-amber-200 text-amber-900',
      icon: <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />,
    },
    error: {
      container: 'bg-red-50 border-red-200 text-red-900',
      icon: <AlertCircle className="w-4 h-4 text-red-600 shrink-0 mt-0.5" />,
    },
    success: {
      container: 'bg-emerald-50 border-emerald-200 text-emerald-900',
      icon: <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />,
    },
  };

  const style = typeStyles[type];

  return (
    <div className={`flex items-start gap-3 p-4 rounded-md border text-sm ${style.container} ${className}`} role="alert">
      {style.icon}
      <div className="flex-1 flex flex-col gap-1">
        {title && <h4 className="font-semibold tracking-tight">{title}</h4>}
        <div className="text-xs leading-relaxed opacity-90">{children}</div>
      </div>
      {onClose && (
        <button
          onClick={onClose}
          aria-label="Close alert"
          className="text-slate-500 hover:text-slate-800 p-0.5 rounded transition-colors"
        >
          <X className="w-4 h-4" />
        </button>
      )}
    </div>
  );
};

export default Alert;
