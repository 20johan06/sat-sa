import React from 'react';

export interface BreadcrumbItem {
  label: string;
  href?: string;
}

export interface PageHeaderProps {
  breadcrumbs?: BreadcrumbItem[];
  title: string;
  description?: string;
  actions?: React.ReactNode;
  badges?: React.ReactNode;
  className?: string;
}

export const PageHeader: React.FC<PageHeaderProps> = ({
  breadcrumbs,
  title,
  description,
  actions,
  badges,
  className = '',
}) => {
  return (
    <div className={`flex flex-col gap-2 pb-5 border-b border-slate-200 mb-6 ${className}`}>
      {breadcrumbs && breadcrumbs.length > 0 && (
        <nav aria-label="Breadcrumb" className="flex items-center gap-1.5 text-xs text-slate-500 font-mono">
          {breadcrumbs.map((item, idx) => (
            <React.Fragment key={idx}>
              {idx > 0 && <span className="text-slate-400">/</span>}
              {item.href ? (
                <a href={item.href} className="hover:text-slate-900 transition-colors">
                  {item.label}
                </a>
              ) : (
                <span className="text-slate-700 font-medium">{item.label}</span>
              )}
            </React.Fragment>
          ))}
        </nav>
      )}

      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex flex-col gap-1">
          <div className="flex items-center gap-3">
            <h1 className="text-xl font-bold tracking-tight text-slate-900">{title}</h1>
            {badges && <div className="flex items-center gap-2">{badges}</div>}
          </div>
          {description && <p className="text-xs text-slate-600 leading-relaxed max-w-3xl">{description}</p>}
        </div>

        {actions && <div className="flex items-center gap-2.5 shrink-0">{actions}</div>}
      </div>
    </div>
  );
};

export default PageHeader;
