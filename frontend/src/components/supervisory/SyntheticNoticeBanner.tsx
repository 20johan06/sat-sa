import React from 'react';
import { AlertTriangle } from 'lucide-react';

interface SyntheticNoticeBannerProps {
  className?: string;
}

export const SyntheticNoticeBanner: React.FC<SyntheticNoticeBannerProps> = ({ className = '' }) => {
  return (
    <div
      role="region"
      aria-label="Synthetic Validation Environment Disclaimer"
      className={`bg-amber-500/10 border border-amber-500/30 rounded-lg p-3.5 text-amber-900 flex items-start gap-3 shadow-xs ${className}`}
    >
      <div className="p-1 rounded bg-amber-500/20 text-amber-700 shrink-0 mt-0.5">
        <AlertTriangle className="w-4 h-4" />
      </div>
      <div className="flex-1 text-xs">
        <div className="font-bold uppercase tracking-wide text-amber-900 font-mono flex items-center gap-2">
          <span>SYNTHETIC VALIDATION ENVIRONMENT</span>
          <span className="px-1.5 py-0.2 rounded bg-amber-200 text-amber-900 text-[10px] font-mono">
            ISOLATED DATASET
          </span>
        </div>
        <p className="mt-1 text-amber-800 leading-relaxed font-sans">
          This workspace operates strictly on controlled synthetic validation scenarios (<code className="font-mono bg-amber-100 px-1 py-0.5 rounded text-amber-900">SYNTHETIC_VALIDATION</code>). Metrics, confusion matrices, and precision calculations are dynamically evaluated against synthetic ground-truth specifications and do not represent real-world operational CSE telemetry.
        </p>
      </div>
    </div>
  );
};

export default SyntheticNoticeBanner;
