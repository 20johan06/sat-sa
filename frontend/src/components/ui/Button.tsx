import React from 'react';
import { Loader2 } from 'lucide-react';

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
  icon?: React.ReactNode;
  children?: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  isLoading = false,
  icon,
  children,
  className = '',
  disabled,
  ...props
}) => {
  const baseStyles = 'inline-flex items-center justify-center font-medium rounded-md transition-colors focus:outline-none disabled:opacity-50 disabled:cursor-not-allowed select-none border';

  const variantStyles = {
    primary: 'bg-blue-600 hover:bg-blue-700 text-white border-blue-600 shadow-sm active:bg-blue-800',
    secondary: 'bg-white hover:bg-slate-100 text-slate-800 border-slate-300 shadow-sm active:bg-slate-200',
    outline: 'bg-transparent hover:bg-slate-100 text-slate-700 border-slate-300 hover:text-slate-900',
    ghost: 'bg-transparent hover:bg-slate-100 text-slate-600 hover:text-slate-900 border-transparent',
    danger: 'bg-red-600 hover:bg-red-700 text-white border-red-600 shadow-sm active:bg-red-800',
  };

  const sizeStyles = {
    sm: 'text-xs px-2.5 py-1.5 gap-1.5',
    md: 'text-sm px-3.5 py-2 gap-2',
    lg: 'text-base px-4 py-2.5 gap-2.5',
  };

  return (
    <button
      className={`${baseStyles} ${variantStyles[variant]} ${sizeStyles[size]} ${className}`}
      disabled={disabled || isLoading}
      {...props}
    >
      {isLoading ? (
        <Loader2 className="w-4 h-4 animate-spin text-current" />
      ) : (
        icon && <span className="inline-flex shrink-0">{icon}</span>
      )}
      {children && <span>{children}</span>}
    </button>
  );
};

export default Button;
