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
│   │   └── app_router.dart     # go_router StatefulShellRoute, 3 root tabs; Dashboard is real, Services/Settings are placeholders
│   ├── screens/
│   │   ├── dashboard_screen.dart    # First real screen — see docs/tasks/ for what it covers
│   │   └── placeholder_screen.dart  # Stand-in body for Services/Settings until Phase 3 builds them
│   ├── widgets/
│   │   ├── datacom_app_bar.dart     # Shared header (back/title/subtitle/refresh/inbox) used by every screen
│   │   ├── datacom_toast.dart       # Shared transient confirmation (design's "toast" pattern)
│   │   └── latency_chart.dart       # Smoothed line+area chart, translated from the design's SVG path math
│   ├── models/
│   │   └── dashboard_models.dart    # Dashboard-only data classes so far
│   ├── services/
│   │   └── dashboard_repository.dart # Abstract DashboardRepository + MockDashboardRepository (local data)
│   ├── providers/
│   │   └── dashboard_providers.dart  # Riverpod providers wiring the repository to the screen
│   └── theme/
│       └── app_theme.dart      # Light/dark ThemeData + status-color extension from the design's tokens
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
