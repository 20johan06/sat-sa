import React from 'react';
import { Database, ShieldCheck, Clock, FileCheck } from 'lucide-react';
import Badge from '../ui/Badge';

export interface ProvenanceBannerProps {
  cseName?: string;
  cseCode?: string;
  assessmentId?: string;
  datasetVersionId?: string;
  analysisRunId?: string;
  engineVersion?: string;
  runTimestamp?: string;
  className?: string;
}

export const ProvenanceBanner: React.FC<ProvenanceBannerProps> = ({
  cseName,
  cseCode,
  assessmentId,
  datasetVersionId,
  analysisRunId,
  engineVersion = 'v2.0.0-phase5-canonical',
  runTimestamp,
  className = '',
}) => {
  return (
    <div
      role="region"
      aria-label="Supervisory Snapshot Provenance"
      className={`bg-slate-900 text-slate-100 rounded-xl p-4 border border-slate-800 shadow-md ${className}`}
    >
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="p-2.5 rounded-lg bg-blue-600/20 border border-blue-500/30 text-blue-400 shrink-0">
            <ShieldCheck className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="text-xs font-bold uppercase tracking-wider text-blue-400 font-mono">
                SNAPSHOT PROVENANCE
              </span>
              <Badge variant="outline" size="sm" className="border-slate-700 text-slate-300 font-mono">
                {engineVersion}
              </Badge>
            </div>
            <h3 className="text-sm font-bold text-white mt-0.5 font-mono">
              {cseName ? `${cseName} (${cseCode || 'N/A'})` : 'Authoritative Supervisory Dataset'}
            </h3>
          </div>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 text-xs font-mono">
          {assessmentId && (
            <div className="bg-slate-800/60 px-3 py-1.5 rounded-md border border-slate-700/50">
              <div className="text-[10px] text-slate-400 flex items-center gap-1">
                <FileCheck className="w-3 h-3 text-slate-400" /> Assessment ID
              </div>
              <div className="text-slate-200 font-semibold truncate select-all">{assessmentId.slice(0, 13)}...</div>
            </div>
          )}

          {datasetVersionId && (
            <div className="bg-slate-800/60 px-3 py-1.5 rounded-md border border-slate-700/50">
              <div className="text-[10px] text-slate-400 flex items-center gap-1">
                <Database className="w-3 h-3 text-slate-400" /> Dataset Version
              </div>
              <div className="text-slate-200 font-semibold truncate select-all">{datasetVersionId.slice(0, 13)}...</div>
            </div>
          )}

          {analysisRunId && (
            <div className="bg-slate-800/60 px-3 py-1.5 rounded-md border border-slate-700/50">
              <div className="text-[10px] text-slate-400 flex items-center gap-1">
                <FileCheck className="w-3 h-3 text-slate-400" /> Analysis Run ID
              </div>
              <div className="text-slate-200 font-semibold truncate select-all">{analysisRunId.slice(0, 13)}...</div>
            </div>
          )}

          {runTimestamp && (
            <div className="bg-slate-800/60 px-3 py-1.5 rounded-md border border-slate-700/50 col-span-2 sm:col-span-1">
              <div className="text-[10px] text-slate-400 flex items-center gap-1">
                <Clock className="w-3 h-3 text-slate-400" /> Executed At
              </div>
              <div className="text-slate-200 font-semibold truncate">{runTimestamp}</div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ProvenanceBanner;
