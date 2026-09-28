# Session: Basic app shell & navigation (Phase 2)

**Date:** 2026-09-28

## What happened
- User said "continue" against the roadmap for the third time in a row on items I'd been flagging as crossing into real Dart code (AGENT.md rule 1). Given the repeated, consistent signal, treated it as approval to proceed with the remaining Phase 2 items rather than asking again.
- Replaced the default `flutter create` counter demo with a real (but minimal) app shell:
  - `lib/theme/app_theme.dart` — light/dark `ThemeData` built from the color tokens documented in DESIGN_SUMMARY.md, plus a `DataComStatusColors` `ThemeExtension` for the ok/warn semantic colors the design uses everywhere (Material's `ColorScheme` only has `error`, not `success`/`warning`).
  - `lib/router/app_router.dart` — `go_router` `StatefulShellRoute.indexedStack` with 3 branches (`/dashboard`, `/services`, `/settings`), matching NAVIGATION_MAP.md's root tabs. Each branch currently renders a shared `PlaceholderScreen` — real screen content is explicitly Phase 3, not this session.
  - `lib/screens/placeholder_screen.dart` — trivial stand-in widget.
  - `lib/main.dart` — rewritten: `EasyLocalization` (en-US/ru-RU, `assets/lang`) wrapping `ProviderScope` (Riverpod) wrapping `MaterialApp.router` using the new theme and router.
  - `test/widget_test.dart` — replaced the counter test (no longer applicable) with a smoke test that pumps the real app and checks all 3 tab labels render.
- Updated ROADMAP.md and FOLDER_STRUCTURE.md to match.

## Decisions made
- Used Flutter's standard `NavigationBar` for the bottom tabs rather than the design's custom floating pill nav bar — that visual detail belongs to Phase 3 (it's specific screen/component polish, not shell plumbing).
- Did not create `lib/widgets/`, `lib/models/`, `lib/services/` yet — no real code needs them yet, and AGENT.md's swappability rule explicitly says not to add abstractions before something needs them.
- Did not add a fonts package/asset (the design uses Instrument Sans + IBM Plex Mono via Google Fonts) — flagged as a follow-up rather than silently adding another dependency (e.g. `google_fonts`) beyond what was asked.

## Open questions / follow-ups
- **None of this has been run.** This environment has no `flutter` on PATH (confirmed last session), so `flutter analyze` / `flutter test` / `flutter run` have not been executed against any of this code. Please run them locally before trusting it — there could be import, API, or version-mismatch issues (e.g. go_router/easy_localization API surface can shift between versions) I can't catch without the toolchain.
- Custom floating pill nav bar (vs. the current standard `NavigationBar`), and wiring actual fonts, are both left for Phase 3.
- Next roadmap item after this is Phase 3: building real screens one at a time, starting presumably with Dashboard per NAVIGATION_MAP.md.
