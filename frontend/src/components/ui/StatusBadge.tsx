import React from 'react';
import { CheckCircle2, AlertTriangle, MinusCircle, HelpCircle, Activity } from 'lucide-react';

export interface StatusBadgeProps {
  status: string;
  size?: 'sm' | 'md';
  className?: string;
}

export const StatusBadge: React.FC<StatusBadgeProps> = ({
  status,
  size = 'md',
  className = '',
}) => {
  const norm = (status || '').toUpperCase();

  let styles = 'bg-slate-100 text-slate-700 border-slate-200';
  let icon: React.ReactNode = <Activity className="w-3 h-3 text-slate-500" />;
  let label = status;

  if (norm === 'SUFFICIENT' || norm === 'HEALTHY' || norm === 'ACTIVE' || norm === 'CONNECTED' || norm === 'OK') {
    styles = 'bg-emerald-50 text-emerald-800 border-emerald-200 font-medium';
    icon = <CheckCircle2 className="w-3 h-3 text-emerald-600" />;
  } else if (norm === 'NO_FINDINGS' || norm === 'NO_FINDINGS_SUFFICIENT') {
    styles = 'bg-blue-50 text-blue-800 border-blue-200 font-medium';
    icon = <CheckCircle2 className="w-3 h-3 text-blue-600" />;
    label = 'NO FINDINGS';
  } else if (norm === 'EXPECTATION_NOT_CONFIGURED' || norm === 'NOT_CONFIGURED') {
    styles = 'bg-slate-100 text-slate-600 border-slate-200';
    icon = <MinusCircle className="w-3 h-3 text-slate-400" />;
    label = 'NOT CONFIGURED';
  } else if (norm === 'DEGRADED' || norm === 'UNAVAILABLE' || norm === 'WARNING') {
    styles = 'bg-amber-50 text-amber-800 border-amber-200 font-medium';
    icon = <AlertTriangle className="w-3 h-3 text-amber-600" />;
  } else if (norm === 'NEW') {
    styles = 'bg-sky-50 text-sky-800 border-sky-200 font-medium';
    icon = <Activity className="w-3 h-3 text-sky-600" />;
  } else if (norm === 'SECTOR_PEER_GROUP') {
    styles = 'bg-indigo-50 text-indigo-800 border-indigo-200 font-medium';
    icon = <CheckCircle2 className="w-3 h-3 text-indigo-600" />;
    label = 'SECTOR PEER GROUP';
  } else if (norm === 'POPULATION_FALLBACK') {
    styles = 'bg-amber-50 text-amber-800 border-amber-200 font-medium';
    icon = <HelpCircle className="w-3 h-3 text-amber-600" />;
    label = 'POPULATION FALLBACK';
  }

  const sizeStyles = {
    sm: 'text-[10px] px-2 py-0.5 gap-1 font-mono tracking-wider',
    md: 'text-xs px-2.5 py-1 gap-1.5 font-mono tracking-wider',
  };

  return (
    <span
      className={`inline-flex items-center rounded-full border uppercase select-none ${styles} ${sizeStyles[size]} ${className}`}
    >
      <span className="inline-flex shrink-0">{icon}</span>
      <span>{label}</span>
    </span>
  );
};

export default StatusBadge;
