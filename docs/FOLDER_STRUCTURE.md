# Folder Structure

This documents the current repo layout. Update this file whenever the structure changes meaningfully.

## Current

```
DataCom/
├── AGENT.md                  # Entry point for AI agents working on this repo
├── design-reference/         # Imported source design (DataCom Calm), reference only
├── docs/
│   ├── ROADMAP.md
│   ├── DESIGN_SUMMARY.md
│   ├── NAVIGATION_MAP.md
│   ├── FOLDER_STRUCTURE.md   # This file
│   ├── PLAY_STORE_CHECKLIST.md
│   ├── sessions/             # One file per work session
│   └── tasks/                # One file per completed task/feature
├── android/                  # Flutter-generated Android project (package id: com.datacom.datacom)
├── ios/                      # Flutter-generated iOS project
├── linux/, macos/, windows/, web/  # Flutter-generated desktop/web targets (unused for this app)
├── assets/
│   └── lang/                 # Localization JSON: en-US.json, ru-RU.json
├── lib/
│   ├── main.dart               # App entry point — EasyLocalization + Riverpod + go_router wired up
│   ├── router/
│   │   └── app_router.dart     # go_router StatefulShellRoute — all 3 root tabs are real screens now
│   ├── screens/
│   │   ├── dashboard_screen.dart      # Dashboard (root)
│   │   ├── inbox_screen.dart          # Notifications/Inbox (alerts + issues tabs)
│   │   ├── alerts_screen.dart         # Alerts (full list, filter chips)
│   │   ├── alert_detail_screen.dart   # Alert detail (metrics, trace console, snooze)
│   │   ├── services_screen.dart       # Services (root) — grouped connections + cloud cards
│   │   ├── settings_screen.dart       # Settings (root) — dark toggle, grouped settings, wipe-data confirm
│   │   ├── add_connection_type_screen.dart  # Add connection — connector type picker
│   │   ├── add_connection_form_screen.dart  # Add connection — form (test/save)
│   │   ├── database_detail_screen.dart  # Database detail (Health/Queries/Schema/SQL tabs)
│   │   ├── table_detail_screen.dart     # Table detail (Columns/Indexes/Rows tabs)
│   │   ├── redis_detail_screen.dart     # Redis detail (Health/Keys/Slow log tabs)
│   │   ├── bucket_detail_screen.dart    # Object storage bucket detail (object list)
│   │   ├── vercel_detail_screen.dart    # Vercel detail (deployments + build log)
│   │   ├── keys_screen.dart             # Keys & credentials (list)
│   │   ├── key_detail_screen.dart       # Credential detail (reveal/verify/save/delete)
│   │   ├── cloudflare_detail_screen.dart  # Cloudflare detail (Zones/Workers/Security tabs)
│   │   ├── monitor_screen.dart            # Sentry-style monitoring (reuses dashboard/alerts data, no new repository)
│   │   └── laravel_cloud_screen.dart      # Laravel Cloud — no design template exists for this one, see its own doc comment
│   ├── widgets/
│   │   ├── datacom_app_bar.dart      # Shared header (back/title/subtitle/refresh/inbox) used by every screen
│   │   ├── datacom_bottom_nav.dart   # Floating pill nav, icon-only — custom-painted from the design's exact SVG paths
│   │   ├── datacom_card.dart         # Shared rounded/outlined card surface
│   │   ├── datacom_console.dart      # Shared dark monospace log/trace viewer (alert traces, EXPLAIN plans, build logs)
│   │   ├── datacom_segmented_tabs.dart  # Shared in-page tab pill switcher (Health/Keys/Slowlog-style rows)
│   │   ├── datacom_sheet.dart        # Shared bottom-sheet action menu (design's "sheet" pattern)
│   │   ├── datacom_toast.dart        # Shared transient confirmation (design's "toast" pattern)
│   │   ├── latency_chart.dart        # Smoothed line+area chart, translated from the design's SVG path math
│   │   └── status_badge.dart         # Small severity pill (CRITICAL/WARNING/ERROR)
│   ├── models/
│   │   ├── status_level.dart       # Shared StatusLevel enum (ok/warn/critical/info)
│   │   ├── console_emphasis.dart   # Shared ConsoleEmphasis enum for DataComConsole lines
│   │   ├── dashboard_models.dart   # Dashboard-specific data classes
│   │   ├── alert_models.dart       # Alert/Issue/trace data classes
│   │   ├── service_models.dart     # Connection/ConnectionGroup/CloudCard data + the static connectorTypeGroups catalog
│   │   ├── database_models.dart    # Database/Table detail data classes
│   │   ├── redis_models.dart       # Redis detail data classes
│   │   ├── storage_models.dart     # StorageObject
│   │   ├── vercel_models.dart      # Deployment/LogLine
│   │   ├── credential_models.dart  # Credential
│   │   └── cloudflare_models.dart  # Cloudflare detail data classes (reuses LogLine from vercel_models.dart)
│   ├── services/
│   │   ├── dashboard_repository.dart   # Abstract DashboardRepository + MockDashboardRepository (local data)
│   │   ├── alerts_repository.dart      # Abstract AlertsRepository + MockAlertsRepository (local data)
│   │   ├── services_repository.dart    # Abstract ServicesRepository + MockServicesRepository (local data)
│   │   ├── database_repository.dart    # Abstract DatabaseRepository + MockDatabaseRepository (local data)
│   │   ├── redis_repository.dart       # Abstract RedisRepository + MockRedisRepository (local data)
│   │   ├── storage_repository.dart     # Abstract StorageRepository + MockStorageRepository (local data)
│   │   ├── vercel_repository.dart      # Abstract VercelRepository + MockVercelRepository (local data)
│   │   ├── credentials_repository.dart # Abstract CredentialsRepository + MockCredentialsRepository (local data)
│   │   └── cloudflare_repository.dart  # Abstract CloudflareRepository + MockCloudflareRepository (local data)
│   ├── providers/
│   │   ├── dashboard_providers.dart    # Riverpod providers wiring the dashboard repository to its screen
│   │   ├── alerts_providers.dart       # Riverpod providers wiring the alerts repository to inbox/alerts/detail
│   │   ├── services_providers.dart     # Riverpod providers wiring the services repository to its screen
│   │   ├── theme_providers.dart        # isDarkModeProvider — drives MaterialApp's themeMode from Settings' toggle
│   │   ├── database_providers.dart     # Family providers keyed by connectionId (+ table name for TableDetailScreen)
│   │   ├── redis_providers.dart        # Family provider keyed by connectionId
│   │   ├── storage_providers.dart      # Family provider keyed by bucketId
│   │   ├── vercel_providers.dart       # Family provider keyed by connectionId
│   │   ├── credentials_providers.dart  # List provider + family provider keyed by index
│   │   └── cloudflare_providers.dart   # Family provider keyed by connectionId
│   └── theme/
│       └── app_theme.dart      # Light/dark ThemeData + status-color extension/helper from the design's tokens
├── test/
│   └── widget_test.dart        # Smoke test: app shell renders with 3 tabs
├── LICENSE
├── pubspec.yaml
└── analysis_options.yaml
```

`widgets/`, `models/`, `services/`, and `providers/` were created for the Dashboard screen specifically, not pre-built — each new screen adds its own model/repository/provider files the same way, named for that screen (e.g. `services_repository.dart`), while shared UI (like `datacom_app_bar.dart`) goes in `widgets/` once a second screen needs it too.

## Target (Phase 3+)

```
lib/
├── main.dart
├── screens/       # One file per screen (see docs/NAVIGATION_MAP.md)
├── widgets/       # Shared/reusable widgets
├── models/        # Data models, one file per screen/domain
├── services/      # Repositories / connector clients / secure storage
├── providers/     # Riverpod providers wiring services to screens
├── router/        # go_router route table
└── theme/         # Colors, typography, shared styling
assets/
├── lang/          # en-US.json, ru-RU.json
├── images/
└── fonts/
```

This target layout follows [NAVIGATION_MAP.md](NAVIGATION_MAP.md). Every folder now has at least one real file from the Dashboard screen; remaining screens (Phase 3) each add their own.
