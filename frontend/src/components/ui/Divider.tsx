import React from 'react';

export interface DividerProps {
  orientation?: 'horizontal' | 'vertical';
  className?: string;
}

export const Divider: React.FC<DividerProps> = ({
  orientation = 'horizontal',
  className = '',
}) => {
  if (orientation === 'vertical') {
    return <div className={`w-px bg-slate-200 self-stretch ${className}`} role="separator" />;
  }
  return <hr className={`w-full border-t border-slate-200 my-4 ${className}`} role="separator" />;
};

export default Divider;
