import React from 'react';
import { AlertOctagon, AlertTriangle, AlertCircle, Info } from 'lucide-react';

export type CanonicalSeverity = 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW';

export interface SeverityBadgeProps {
  severity: CanonicalSeverity | string;
  size?: 'sm' | 'md' | 'lg';
  showIcon?: boolean;
  className?: string;
}

export const SeverityBadge: React.FC<SeverityBadgeProps> = ({
  severity,
  size = 'md',
  showIcon = true,
  className = '',
}) => {
  const normalizedSeverity = (severity || '').toUpperCase() as CanonicalSeverity;

  const severityConfig: Record<CanonicalSeverity, {
    label: string;
    icon: React.ReactNode;
    styles: string;
    textSymbol: string;
  }> = {
    CRITICAL: {
      label: 'CRITICAL',
      icon: <AlertOctagon className="w-3.5 h-3.5 text-red-700" />,
      styles: 'bg-red-50 text-red-800 border-red-200 font-semibold',
      textSymbol: '[!]',
    },
    HIGH: {
      label: 'HIGH',
      icon: <AlertTriangle className="w-3.5 h-3.5 text-amber-700" />,
      styles: 'bg-amber-50 text-amber-800 border-amber-200 font-semibold',
      textSymbol: '[▲]',
    },
    MEDIUM: {
      label: 'MEDIUM',
      icon: <AlertCircle className="w-3.5 h-3.5 text-yellow-700" />,
      styles: 'bg-yellow-50 text-yellow-800 border-yellow-200 font-semibold',
      textSymbol: '[■]',
    },
    LOW: {
      label: 'LOW',
      icon: <Info className="w-3.5 h-3.5 text-blue-700" />,
      styles: 'bg-blue-50 text-blue-800 border-blue-200 font-semibold',
      textSymbol: '[●]',
    },
  };

  const config = severityConfig[normalizedSeverity] || severityConfig.LOW;

  const sizeStyles = {
    sm: 'text-[10px] px-2 py-0.5 gap-1 font-mono tracking-wider',
    md: 'text-xs px-2.5 py-1 gap-1.5 font-mono tracking-wider',
    lg: 'text-sm px-3 py-1.5 gap-2 font-mono tracking-wider',
  };

  return (
    <span
      className={`inline-flex items-center rounded-full border uppercase select-none ${config.styles} ${sizeStyles[size]} ${className}`}
      aria-label={`Severity: ${config.label}`}
      title={`Severity: ${config.label}`}
    >
      {showIcon && (
        <span className="inline-flex items-center gap-1 shrink-0">
          {config.icon}
          <span className="sr-only">{config.textSymbol}</span>
        </span>
      )}
      <span>{config.label}</span>
    </span>
  );
};

export default SeverityBadge;
