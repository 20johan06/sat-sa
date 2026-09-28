import React from 'react';

export interface SelectOption {
  value: string;
  label: string;
  disabled?: boolean;
}

export interface SelectProps extends React.SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  options: SelectOption[];
  error?: string;
  helperText?: string;
}

export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(({
  label,
  options,
  error,
  helperText,
  className = '',
  id,
  disabled,
  ...props
}, ref) => {
  const generatedId = React.useId();
  const selectId = id || generatedId;

  return (
    <div className="flex flex-col gap-1.5 w-full">
      {label && (
        <label htmlFor={selectId} className="text-xs font-semibold text-slate-700">
          {label}
        </label>
      )}
      <select
        ref={ref}
        id={selectId}
        disabled={disabled}
        className={`
          w-full bg-white text-slate-900 border text-sm rounded-md px-3 py-2
          shadow-sm transition-colors focus:outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-600
          disabled:bg-slate-100 disabled:opacity-70 disabled:cursor-not-allowed cursor-pointer
          ${error ? 'border-red-500 focus:border-red-600' : 'border-slate-300'}
          ${className}
        `}
        {...props}
      >
        {options.map((opt) => (
          <option key={opt.value} value={opt.value} disabled={opt.disabled} className="bg-white text-slate-900">
            {opt.label}
          </option>
        ))}
      </select>
      {error ? (
        <p className="text-xs text-red-600 font-medium">{error}</p>
      ) : helperText ? (
        <p className="text-xs text-slate-500">{helperText}</p>
      ) : null}
    </div>
  );
});

Select.displayName = 'Select';
export default Select;
