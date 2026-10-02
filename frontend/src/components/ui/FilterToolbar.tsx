import React from 'react';
import { Search, RotateCcw } from 'lucide-react';
import Input from './Input';
import Select from './Select';
import Button from './Button';

export interface FilterOption {
  value: string;
  label: string;
}

export interface FilterToolbarProps {
  searchTerm?: string;
  onSearchChange?: (val: string) => void;
  searchPlaceholder?: string;
  categoryValue?: string;
  onCategoryChange?: (val: string) => void;
  categoryOptions?: FilterOption[];
  severityValue?: string;
  onSeverityChange?: (val: string) => void;
  severityOptions?: FilterOption[];
  statusValue?: string;
  onStatusChange?: (val: string) => void;
  statusOptions?: FilterOption[];
  onResetFilters?: () => void;
  className?: string;
}

export const FilterToolbar: React.FC<FilterToolbarProps> = ({
  searchTerm,
  onSearchChange,
  searchPlaceholder = 'Search by code, title, or reference...',
  categoryValue,
  onCategoryChange,
  categoryOptions = [],
  severityValue,
  onSeverityChange,
  severityOptions = [],
  statusValue,
  onStatusChange,
  statusOptions = [],
  onResetFilters,
  className = '',
}) => {
  const hasActiveFilters = Boolean(
    searchTerm || categoryValue || severityValue || statusValue
  );

  return (
    <div className={`bg-white p-4 rounded-xl border border-slate-200 shadow-xs space-y-3 ${className}`}>
      <div className="flex flex-col md:flex-row items-stretch md:items-center gap-3">
        {/* Search Input */}
        {onSearchChange !== undefined && (
          <div className="flex-1">
            <Input
              type="text"
              placeholder={searchPlaceholder}
              value={searchTerm || ''}
              onChange={(e) => onSearchChange(e.target.value)}
              startIcon={<Search className="w-4 h-4 text-slate-400" />}
            />
          </div>
        )}

        {/* Filter Dropdowns */}
        <div className="flex flex-wrap items-center gap-2.5">
          {onCategoryChange && categoryOptions.length > 0 && (
            <div className="w-40">
              <Select
                value={categoryValue || ''}
                onChange={(e) => onCategoryChange(e.target.value)}
                options={[
                  { value: '', label: 'All Categories' },
                  ...categoryOptions,
                ]}
              />
            </div>
          )}

          {onSeverityChange && severityOptions.length > 0 && (
            <div className="w-36">
              <Select
                value={severityValue || ''}
                onChange={(e) => onSeverityChange(e.target.value)}
                options={[
                  { value: '', label: 'All Severities' },
                  ...severityOptions,
                ]}
              />
            </div>
          )}

          {onStatusChange && statusOptions.length > 0 && (
            <div className="w-36">
              <Select
                value={statusValue || ''}
                onChange={(e) => onStatusChange(e.target.value)}
                options={[
                  { value: '', label: 'All Statuses' },
                  ...statusOptions,
                ]}
              />
            </div>
          )}

          {/* Reset Filters Button */}
          {hasActiveFilters && onResetFilters && (
            <Button
              variant="outline"
              size="sm"
              onClick={onResetFilters}
              icon={<RotateCcw className="w-3.5 h-3.5" />}
              className="text-slate-600 border-slate-300 hover:bg-slate-50"
            >
              Reset
            </Button>
          )}
        </div>
      </div>
    </div>
  );
};

export default FilterToolbar;
