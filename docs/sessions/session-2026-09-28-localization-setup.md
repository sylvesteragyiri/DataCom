# Session: Localization setup

**Date:** 2026-09-28

## What happened
- User decided the app supports multiple languages from the start: English (en-US) and Russian (ru-RU).
- Created `assets/lang/en-US.json` and `assets/lang/ru-RU.json`, each seeded with just `app_name` for now (no real UI strings exist yet since no screens are built) — registered `assets/lang/` in `pubspec.yaml`.
- Documented the approach in NAVIGATION_MAP.md: proposed `easy_localization` package (its default convention already matches a JSON-per-locale assets folder), en-US as default/fallback locale, and a swappability note (screens call a single translation function, never branch on locale directly).
- Updated FOLDER_STRUCTURE.md and ROADMAP.md to reflect the new folder and pending dependency.

## Decisions made
- Locales at launch: en-US (default), ru-RU. More locales can be added later as more `.json` files in the same folder.
- Translation keys get filled in per-screen as Phase 3 builds each screen, not translated in bulk ahead of the UI existing — avoids maintaining strings for screens that don't exist yet.

## Open questions / follow-ups
- `easy_localization` is proposed, not confirmed — still pending the same sign-off as Riverpod/go_router/flutter_secure_storage before any of these get added to `pubspec.yaml` dependencies.
- No actual Dart localization wiring (`EasyLocalization` widget, `context.tr()` calls) exists yet — that's Phase 3 work, tied to when the app shell/navigation gets built.
