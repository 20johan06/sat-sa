import React from 'react';
import { Routes, Route } from 'react-router-dom';
import AppShell from '../layouts/AppShell';
import CSEContextLayout from '../layouts/CSEContextLayout';
import { ProtectedRoute } from '../components/ProtectedRoute';

import { LoginPage } from '../pages/LoginPage';
import CSERegistryPage from '../pages/CSERegistryPage';
import CSEOverviewPage from '../pages/CSEOverviewPage';
import AnalyticsConsolePage from '../pages/AnalyticsConsolePage';
import CSEFindingsPage from '../pages/CSEFindingsPage';
import NationalFindingsPage from '../pages/NationalFindingsPage';
import FindingDetailPage from '../pages/FindingDetailPage';
import PeerBenchmarksPage from '../pages/PeerBenchmarksPage';
import ExecutiveReportsPage from '../pages/ExecutiveReportsPage';
import IngestionAuditPage from '../pages/IngestionAuditPage';
import AssessmentWorkspacePage from '../pages/AssessmentWorkspacePage';
import { CSECapabilityAssessmentPage } from '../pages/CSECapabilityAssessmentPage';
import SystemHealthPage from '../pages/SystemHealthPage';
import NotFoundPage from '../pages/NotFoundPage';

export const AppRoutes: React.FC = () => {
  return (
    <Routes>
      {/* Public Login Route */}
      <Route path="/login" element={<LoginPage />} />

      {/* Protected Main Application Routes */}
      <Route
        path="/"
        element={
          <ProtectedRoute>
            <AppShell />
          </ProtectedRoute>
        }
      >
        {/* National / Root Level Routes */}
        <Route index element={<CSERegistryPage />} />
        <Route path="findings" element={<NationalFindingsPage />} />
        <Route path="findings/:finding_id" element={<FindingDetailPage />} />
        <Route path="system/health" element={<SystemHealthPage />} />

        {/* Nested Entity Context Routes (/cses/:cse_id/*) */}
        <Route path="cses/:cse_id" element={<CSEContextLayout />}>
          <Route index element={<CSEOverviewPage />} />
          <Route path="assessments" element={<AssessmentWorkspacePage />} />
          <Route path="capability-assessment" element={<CSECapabilityAssessmentPage />} />
          <Route
            path="analytics"
            element={
              <ProtectedRoute allowedRoles={['ADMIN', 'SUPERVISOR']}>
                <AnalyticsConsolePage />
              </ProtectedRoute>
            }
          />
          <Route path="findings" element={<CSEFindingsPage />} />
          <Route path="benchmarks" element={<PeerBenchmarksPage />} />
          <Route path="reports" element={<ExecutiveReportsPage />} />
          <Route
            path="ingestion"
            element={
              <ProtectedRoute allowedRoles={['ADMIN', 'SUPERVISOR']}>
                <IngestionAuditPage />
              </ProtectedRoute>
            }
          />
        </Route>

        {/* Fallback 404 Route */}
        <Route path="*" element={<NotFoundPage />} />
      </Route>
    </Routes>
  );
};

export default AppRoutes;
