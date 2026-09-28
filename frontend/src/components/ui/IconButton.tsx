import React from 'react';

export interface IconButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  'aria-label': string;
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'header';
  size?: 'sm' | 'md' | 'lg';
  icon: React.ReactNode;
}

export const IconButton: React.FC<IconButtonProps> = ({
  'aria-label': ariaLabel,
  variant = 'ghost',
  size = 'md',
  icon,
  className = '',
  disabled,
  ...props
}) => {
  const baseStyles = 'inline-flex items-center justify-center rounded-md transition-colors focus:outline-none disabled:opacity-50 disabled:cursor-not-allowed select-none border';

  const variantStyles = {
    primary: 'bg-blue-600 hover:bg-blue-700 text-white border-blue-600',
    secondary: 'bg-white hover:bg-slate-100 text-slate-700 border-slate-300 shadow-sm',
    outline: 'bg-transparent hover:bg-slate-100 text-slate-700 border-slate-300',
    ghost: 'bg-transparent hover:bg-slate-100 text-slate-600 hover:text-slate-900 border-transparent',
    header: 'bg-transparent hover:bg-slate-800 text-slate-300 hover:text-white border-transparent',
  };

  const sizeStyles = {
    sm: 'p-1.5 text-xs',
    md: 'p-2 text-sm',
    lg: 'p-2.5 text-base',
  };

  return (
    <button
      aria-label={ariaLabel}
      title={ariaLabel}
      className={`${baseStyles} ${variantStyles[variant]} ${sizeStyles[size]} ${className}`}
      disabled={disabled}
      {...props}
    >
      {icon}
    </button>
  );
};

export default IconButton;
