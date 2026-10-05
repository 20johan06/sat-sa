# SAT-SA Mobile Companion (Android)

**Supervisory Analytics Tool for SOC Assessment**  
*Problem Statement ID: SIH26157*

## Executive Overview

`satsa_mobile` is an offline-first companion application designed for authorized supervisory examiners on Android devices. It functions as an air-gapped, offline analytics and assessment viewer that operates independently of any network connectivity.

## Technology Foundation

- **Framework**: Flutter 3.x / Dart 3.x (Null Safety)
- **Local Persistence**: Drift ORM over native SQLite (`sqflite`)
- **Cryptography**: AES-256-GCM AEAD (`cryptography` / `flutter_secure_storage`)
- **Package Transfer**: `.satsa` package bundle import/export contract (Phase 18 compatible)

## Air-Gap Compliance Guarantee

This application enforces strict air-gap compliance:
- ❌ No Internet access required or requested
- ❌ Zero Cloud SDKs (No Firebase, Supabase, AWS, Azure, Google Cloud)
- ❌ Zero Remote AI API dependencies (No OpenAI, Gemini, Claude APIs)
- ❌ Zero Background Telemetry
- ✅ 100% Local Device Storage & Execution
