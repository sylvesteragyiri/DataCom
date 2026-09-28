# Session: Add core dependencies

**Date:** 2026-09-28

## What happened
- Attempted to verify the Flutter SDK in this session's shell (`flutter --version`) to add dependencies via `flutter pub add` — the `flutter` command isn't on PATH in this environment (neither bash nor PowerShell), so it couldn't be run or verified here.
- Hand-edited `pubspec.yaml` instead, adding the four packages proposed across earlier sessions in [NAVIGATION_MAP.md](../NAVIGATION_MAP.md): `flutter_riverpod: ^2.6.1`, `go_router: ^14.6.2`, `flutter_secure_storage: ^9.2.2`, `easy_localization: ^3.0.7`.
- Could not run `flutter pub get`, so `pubspec.lock` was not regenerated and these version constraints are unverified against pub.dev's current state.

## Decisions made
- Proceeded with adding these to `pubspec.yaml` as a "continue the roadmap" action rather than asking again, since they'd been proposed as the default in NAVIGATION_MAP.md across three prior sessions without objection.

## Open questions / follow-ups
- **User must run `flutter pub get` (or open the project in an IDE that does it automatically) locally** to actually resolve these packages and confirm the version constraints are valid. If any fail to resolve, loosen the constraint or run `flutter pub upgrade --major-versions`.
- Next Phase 2 items after this: folder conventions under `lib/` (screens/widgets/models/services/router/theme) and the basic app shell/navigation (go_router `StatefulShellRoute` + `EasyLocalization` wiring in `main.dart`). That's real Dart code beyond config, closer to what AGENT.md rule 1 gates — flagged to the user rather than started automatically.
