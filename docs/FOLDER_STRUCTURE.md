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
│   ├── main.dart              # App entry point — EasyLocalization + Riverpod + go_router wired up
│   ├── router/
│   │   └── app_router.dart    # go_router StatefulShellRoute, 3 root tabs (placeholder screens)
│   ├── screens/
│   │   └── placeholder_screen.dart  # Stand-in body for each tab until Phase 3 builds real screens
│   └── theme/
│       └── app_theme.dart     # Light/dark ThemeData from the design's color tokens
├── test/
│   └── widget_test.dart       # Smoke test: app shell renders with 3 tabs
├── LICENSE
├── pubspec.yaml
└── analysis_options.yaml
```

`lib/widgets/`, `lib/models/`, and `lib/services/` don't exist yet — per the swappability/no-premature-abstraction rule in AGENT.md, they get created when the first screen in Phase 3 actually needs them, not ahead of time.

## Target (Phase 3+)

```
lib/
├── main.dart
├── screens/       # One folder or file per screen (see docs/NAVIGATION_MAP.md)
├── widgets/       # Shared/reusable widgets
├── models/        # Data models
├── services/      # Repositories / connector clients / secure storage
├── router/        # go_router route table
└── theme/         # Colors, typography, shared styling
assets/
├── lang/          # en-US.json, ru-RU.json (already in place)
├── images/
└── fonts/
```

This target layout follows [NAVIGATION_MAP.md](NAVIGATION_MAP.md). `router/`, `screens/` (with one placeholder), and `theme/` are already in place; `widgets/`, `models/`, `services/`, and real per-screen content are Phase 3.
