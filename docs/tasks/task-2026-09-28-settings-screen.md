# Task: Settings screen (root tab) + functional dark mode

**Completed:** 2026-09-28

## What was built
The third and final root tab, completing all 3 bottom-nav destinations with real screens:
- Dark theme switch — **actually functional**, not a stub: `isDarkModeProvider` (Riverpod `StateProvider<bool>`) now drives `MaterialApp.router`'s `themeMode` in `main.dart`.
- Four grouped settings sections (Connections, Credentials, Monitoring, Data) matching the design exactly, each row navigating or toasting depending on whether its target exists yet.
- "Manage connections" actually switches to the Services tab (`context.go('/services')`).
- "Wipe local data" opens the shared bottom-sheet confirm pattern (destructive action + cancel), matching the design's own confirm-via-sheet flow rather than a plain dialog.
- Deleted `lib/screens/placeholder_screen.dart` — no longer referenced by anything now that all 3 tabs have real screens.

## Files touched
- `lib/providers/theme_providers.dart` (new) — `isDarkModeProvider`
- `lib/main.dart` — `DataComApp` is now a `ConsumerWidget`; wires `themeMode` from the provider
- `lib/screens/settings_screen.dart` (new)
- `lib/router/app_router.dart` — `/settings` now builds `SettingsScreen`; removed the `placeholder_screen.dart` import
- `lib/screens/placeholder_screen.dart` — deleted (dead code after this change)
- `assets/lang/en-US.json`, `assets/lang/ru-RU.json` — full Settings string set in both locales

## Notes / follow-ups
- "Manage connections" row's trailing count is real (computed from `servicesOverviewProvider`); "Keys & credentials" count (6) and the Monitoring/Data values (30 s, 12 rules, 500 ms, 48 MB) are hardcoded to match the design's mock — there's no credentials repository or real settings-persistence layer yet, so these aren't wired to anything that could actually change them.
- Every row that would navigate to a screen that doesn't exist yet (Add a connection, Keys & credentials) shows the "Coming soon" toast rather than a broken route.
- **Still unverified**: no `flutter analyze`/`test`/`run` locally — this is now six screens and a cross-cutting theme change without a single real compile check outside the IDE's inline diagnostics.
