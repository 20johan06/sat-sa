import React from 'react';

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  helperText?: string;
  startIcon?: React.ReactNode;
  endIcon?: React.ReactNode;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(({
  label,
  error,
  helperText,
  startIcon,
  endIcon,
  className = '',
  id,
  disabled,
  ...props
}, ref) => {
  const generatedId = React.useId();
  const inputId = id || generatedId;

  return (
    <div className="flex flex-col gap-1.5 w-full">
      {label && (
        <label htmlFor={inputId} className="text-xs font-semibold text-slate-700">
          {label}
        </label>
      )}
      <div className="relative flex items-center w-full">
        {startIcon && (
          <div className="absolute left-3 pointer-events-none text-slate-400">
            {startIcon}
          </div>
        )}
        <input
          ref={ref}
          id={inputId}
          disabled={disabled}
          className={`
            w-full bg-white text-slate-900 placeholder-slate-400 border text-sm rounded-md px-3 py-2
            shadow-sm transition-colors focus:outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600
            disabled:bg-slate-100 disabled:opacity-70 disabled:cursor-not-allowed
            ${startIcon ? 'pl-9' : ''}
            ${endIcon ? 'pr-9' : ''}
            ${error ? 'border-red-500 focus:border-red-600 focus:ring-red-600' : 'border-slate-300'}
            ${className}
          `}
          {...props}
        />
        {endIcon && (
          <div className="absolute right-3 pointer-events-none text-slate-400">
            {endIcon}
          </div>
        )}
      </div>
      {error ? (
        <p className="text-xs text-red-600 font-medium">{error}</p>
      ) : helperText ? (
        <p className="text-xs text-slate-500">{helperText}</p>
      ) : null}
    </div>
  );
});

Input.displayName = 'Input';
export default Input;
