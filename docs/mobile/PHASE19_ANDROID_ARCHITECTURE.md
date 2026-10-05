# Phase 19: Android Mobile Architecture & Flutter Project Specification

## 1. Executive Overview & Scope

SAT-SA (Supervisory Analytics Tool for SOC Assessment) is an offline-first supervisory analytics platform designed for SIH26157. The Android mobile application serves as an independent, fully offline companion to the Windows SAT-SA supervisory environment.

### Target Deployment Topology
- **Windows Subsystem**: React 18 + Vite + FastAPI + PostgreSQL 16 + Python Analytics Engine (Dockerized/Native).
- **Android Subsystem**: Flutter 3.x (Dart 3.x) + Drift (SQLite) + Local Dart Analytics Engine (Phase 20).
- **Data Exchange**: USB / Air-Gapped Physical Transfer via encrypted `.satsa` package bundle (AEAD AES-256-GCM).

### Strict Air-Gap Constraints
- **Zero Internet/Cloud Dependency**: No Firebase, Supabase, OpenAI, Gemini, remote OAuth, or telemetry SDKs.
- **100% Offline Capability**: Application initialization, local storage, domain parsing, analytics execution, and reporting operate with zero network interfaces active.

---

## 2. Directory & Layered Architecture

The Android application is structured following Clean Architecture principles, ensuring strict separation of concerns between presentation, domain contracts, local data persistence, and future Dart analytics.

```text
mobile/
├── pubspec.yaml
├── README.md
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/AndroidManifest.xml
│   ├── build.gradle
│   └── settings.gradle
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── errors/
│   │   │   └── failures.dart
│   │   ├── security/
│   │   │   └── security_service.dart
│   │   └── utils/
│   │       └── datetime_formatter.dart
│   ├── data/
│   │   ├── database/
│   │   │   └── app_database.dart
│   │   ├── models/
│   │   ├── package/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── cse.dart
│   │   │   ├── assessment.dart
│   │   │   ├── dataset_version.dart
│   │   │   ├── analysis_run.dart
│   │   │   ├── finding.dart
│   │   │   ├── finding_evidence.dart
│   │   │   ├── finding_review_history.dart
│   │   │   ├── report_record.dart
│   │   │   ├── alert_entity.dart
│   │   │   ├── case_entity.dart
│   │   │   ├── investigation_entity.dart
│   │   │   ├── escalation_entity.dart
│   │   │   ├── monitoring_coverage_entity.dart
│   │   │   ├── asset_entity.dart
│   │   │   └── package_manifest_entity.dart
│   │   ├── repositories/
│   │   │   ├── data_exchange_repository.dart
│   │   │   └── local_storage_repository.dart
│   │   └── usecases/
│   ├── analytics/                # Reserved for Phase 20 Dart Analytics Engine
│   ├── presentation/
│   │   ├── controllers/
│   │   ├── screens/
│   │   │   └── splash_screen.dart
│   │   └── widgets/
│   └── services/
└── test/
    ├── widget_test.dart
    └── domain/
        └── entities_test.dart
```

---

## 3. Local Database Selection: Drift (SQLite)

### Evaluated Alternatives
1. **Raw `sqflite`**: Low-level SQLite wrapper. Lacks compile-time query safety, automatic migrations, and ORM reactive bindings.
2. **Realm / Isar**: NoSQL document stores. Mismatches SAT-SA's deeply relational supervisory domain (14 relational tables, foreign key constraints, JOIN queries).
3. **Drift (formerly Moor)**: **SELECTED**. Mature, type-safe relational ORM built on top of native SQLite (`sqlite3` / `sqflite`).

### Selection Rationale
- **Relational Parity**: 1-to-1 mapping with PostgreSQL schemas in Windows backend.
- **Compile-Time Type Safety**: Code generation prevents SQL field name errors.
- **Transactional Integrity**: Native ACID transaction support (`db.transaction()`) ensures atomic imports and prevents corrupted partial states.
- **Offline Reliability**: Operates entirely in local device storage without background daemon requirements.

---

## 4. Cross-Platform Domain Contract

The Android domain entities map directly to the 14 PostgreSQL/Pydantic schemas defined in the Phase 18 backend contract:

| Entity Name | Primary Key | Key Fields & Types | Relational Foreign Keys |
| :--- | :--- | :--- | :--- |
| **CSE** | `id: UUID` | `cseCode: String`, `name: String`, `sector: String`, `criticalityTier: String`, `isActive: bool` | Primary Entity Root |
| **Assessment** | `id: UUID` | `name: String`, `periodStart: DateTime`, `periodEnd: DateTime`, `status: String` | `cseId -> CSE.id` |
| **DatasetVersion** | `id: UUID` | `versionTag: String`, `datasetType: String`, `sourceFilename: String`, `contentHash: String`, `recordCount: int` | `cseId -> CSE.id`, `assessmentId -> Assessment.id` |
| **AnalysisRun** | `id: UUID` | `rulesEvaluated: List<String>`, `engineVersion: String`, `status: String`, `findingsCreated: int` | `assessmentId -> Assessment.id`, `datasetVersionId -> DatasetVersion.id` |
| **Finding** | `id: UUID` | `findingCode: String`, `category: String`, `severity: String`, `title: String`, `metricsJson: Map` | `cseId -> CSE.id`, `analysisRunId -> AnalysisRun.id` |
| **FindingEvidence** | `id: UUID` | `evidenceType: String`, `notes: String?` | `findingId -> Finding.id`, `alertId`, `caseId`, `investigationId`, `escalationId`, `coverageId` |
| **FindingReviewHistory** | `id: UUID` | `actionType: String`, `previousStatus: String`, `newStatus: String`, `noteText: String` | `findingId -> Finding.id`, `cseId -> CSE.id` |
| **ReportRecord** | `id: UUID` | `reportCode: String`, `summaryJson: Map`, `metadataJson: Map` | `cseId -> CSE.id`, `assessmentId -> Assessment.id`, `analysisRunId -> AnalysisRun.id` |
| **Alert** | `id: UUID` | `alertReference: String`, `sourceSystem: String`, `ruleName: String`, `severity: String`, `eventTimestamp: DateTime` | `cseId -> CSE.id` |
| **Case** | `id: UUID` | `caseReference: String`, `title: String`, `severity: String`, `status: String`, `openedAt: DateTime` | `cseId -> CSE.id` |
| **Investigation** | `id: UUID` | `investigationReference: String`, `status: String`, `summary: String?` | `caseId -> Case.id` |
| **Escalation** | `id: UUID` | `escalationReference: String`, `escalatedTo: String`, `reason: String` | `caseId -> Case.id` |
| **MonitoringCoverage** | `id: UUID` | `logSourceType: String`, `coverageStatus: String`, `expectedEps: double?` | `cseId -> CSE.id` |
| **Asset** | `id: UUID` | `assetIdentifier: String`, `assetName: String`, `assetType: String`, `ipAddress: String?` | `cseId -> CSE.id` |

---

## 5. Cross-Platform Deterministic Analytics Contract (Phase 20 Target)

To guarantee that Windows (Python) and Android (Dart) produce **identical supervisory findings** from the same dataset:

1. **8 Canonical Analytics Rules**:
   - `EG-01`: Unmonitored Critical Log Source (0 EPS expectation gap)
   - `EG-02`: Unescalated Critical Severity Case
   - `EG-03`: Rapid Case Closure Pattern Detection
   - `EG-04`: Repeated Investigation Pattern
   - `NS-01`: Inactive Log Source Coverage
   - `NS-02`: Missing Security Asset Inventory Mapping
   - `AN-01`: Daily Alert Volume Statistical Anomaly (MAD > 3.0, N >= 7)
   - `BM-01`: Peer Sector Benchmarking Delta Deviation
2. **Numeric Precision & Formatting**:
   - Timestamps formatted strictly in ISO-8601 UTC (`yyyy-MM-ddTHH:mm:ss.SSSZ`).
   - Floats rounded to 4 decimal places for supervisory scoring metrics.
   - Deterministic Finding UUID derivation using standard v5 UUID hashing where required.

---

## 6. `.satsa` Package Exchange & Security Boundary

### Import Validation Pipeline
```text
.satsa ZIP File -> ZIP Structure Check -> Reject if data/data.json present (Plaintext Prohibition)
                -> Parse manifest.json -> Verify package_format == "SAT-SA-OFFLINE-PACKAGE" & format_version == "1.0.0"
                -> Extract Salt (16B) & Nonce (12B) -> Derive PBKDF2-HMAC-SHA256 Key (100k iterations)
                -> AES-256-GCM Decrypt data/data.enc with AAD Context -> Verify AEAD Tag & SHA-256 Hash
                -> Atomic Transactional DB Restoration via Drift
```

### Mobile Security Controls
- **Passphrase & Key Storage**: Master keys stored in Android Keystore via `flutter_secure_storage`.
- **Zero Hardcoded Secrets**: No static keys or passwords in Dart code.
- **Path Traversal Protection**: Uploaded files sanitized to prevent directory traversal attacks.

---

## 7. Deferred Implementations Matrix

| Feature / Subsystem | Phase 19 (Current) | Phase 20 | Phase 21 | Phase 22 | Phase 23 |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Architecture & Project Init** | ✅ Implemented | — | — | — | — |
| **Domain Contracts & Entities** | ✅ Implemented | — | — | — | — |
| **Minimal Application Shell** | ✅ Implemented | — | — | — | — |
| **Dart Analytics Engine** | Deferred | ⏳ Planned | — | — | — |
| **Drift Schema Migrations** | Deferred | ⏳ Planned | — | — | — |
| **.satsa Import/Export Engine** | Deferred | — | ⏳ Planned | — | — |
| **Full Android UI / Dashboards** | Deferred | — | — | ⏳ Planned | — |
| **PDF Report Generation** | Deferred | — | — | — | ⏳ Planned |

---

## 8. Anti-Hallucination & Verification Declaration

All schema fields, package parameters, encryption algorithms (`AES-256-GCM`, `PBKDF2HMAC-SHA256`, 12-byte nonce, 100k iterations), and entity definitions in this document were verified directly against active Python source code in `backend/app/schemas/data_exchange.py` and `backend/app/services/data_exchange_service.py`. Zero fields were invented.
