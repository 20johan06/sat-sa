import React from 'react';

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode;
  className?: string;
}

export const Card: React.FC<CardProps> = ({ children, className = '', ...props }) => {
  return (
    <div
      className={`bg-white border border-slate-200 rounded-lg shadow-sm text-slate-900 overflow-hidden ${className}`}
      {...props}
    >
      {children}
    </div>
  );
};

export const CardHeader: React.FC<CardProps> = ({ children, className = '', ...props }) => {
  return (
    <div className={`px-5 py-4 border-b border-slate-100 flex flex-col gap-1 ${className}`} {...props}>
      {children}
    </div>
  );
};

export const CardTitle: React.FC<CardProps> = ({ children, className = '', ...props }) => {
  return (
    <h3 className={`text-base font-semibold text-slate-900 tracking-tight flex items-center gap-2 ${className}`} {...props}>
      {children}
    </h3>
  );
};

export const CardDescription: React.FC<CardProps> = ({ children, className = '', ...props }) => {
  return (
    <p className={`text-xs text-slate-500 leading-relaxed ${className}`} {...props}>
      {children}
    </p>
  );
};

export const CardContent: React.FC<CardProps> = ({ children, className = '', ...props }) => {
  return (
    <div className={`p-5 ${className}`} {...props}>
      {children}
    </div>
  );
};

export const CardFooter: React.FC<CardProps> = ({ children, className = '', ...props }) => {
  return (
    <div className={`px-5 py-3 border-t border-slate-100 bg-slate-50/60 flex items-center justify-between gap-3 ${className}`} {...props}>
      {children}
    </div>
  );
};

export default Card;
