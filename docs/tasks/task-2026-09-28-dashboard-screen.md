# Task: Dashboard screen (Phase 3, first screen)

**Completed:** 2026-09-28

## What was built
The first real screen from the design, replacing the `/dashboard` placeholder:
- Critical alert banner (count + detail + "Triage N alerts" CTA)
- 4-up health tiles (connected/healthy/warning/critical), colored via status level
- "Average latency" card: a hand-rolled smoothed line+gradient chart (`CustomPainter`, cubic-bezier logic translated directly from the SVG path math in `design-reference/DataCom Calm.dc.html`), plus peak/p50/p95/throughput stats
- "Live metrics" 2-column grid
- "Activity" timeline list
- Shared `DataComAppBar` (back/title/subtitle/refresh/inbox-with-badge) — the header pattern every screen in the design uses, so built as shared infrastructure rather than duplicated
- Shared `showDataComToast()` helper matching the design's transient-confirmation pattern

## Files touched
- `lib/screens/dashboard_screen.dart` (new)
- `lib/models/dashboard_models.dart` (new) — `StatusLevel` enum + plain data classes, no Flutter/UI imports
- `lib/services/dashboard_repository.dart` (new) — `DashboardRepository` abstract class + `MockDashboardRepository`, per the swappability principle in NAVIGATION_MAP.md
- `lib/providers/dashboard_providers.dart` (new) — Riverpod repository + `FutureProvider`
- `lib/widgets/datacom_app_bar.dart`, `lib/widgets/datacom_toast.dart`, `lib/widgets/latency_chart.dart` (new) — shared, reusable by the next screens
- `lib/router/app_router.dart` — `/dashboard` now builds `DashboardScreen`; nav labels (`Home`/`Services`/`Settings`) localized via `easy_localization`
- `assets/lang/en-US.json`, `assets/lang/ru-RU.json` — all Dashboard UI-chrome strings added in both locales
- `test/widget_test.dart` — updated expected nav label text (`Dashboard` → `Home`, matching the design's actual nav label)

## Notes / follow-ups
- Mock data only (`MockDashboardRepository`), mirroring the exact values from the design's script — no real connector wired up.
- Deliberately **not** translated: activity feed text, alert detail text, and other data-shaped content — treated as data from monitored systems, not app UI chrome. Only actual interface strings (titles, labels, buttons, toasts) went into `assets/lang/`.
- Still using Flutter's standard `NavigationBar` rather than the design's custom floating pill nav — a visual-polish item for later, not blocking.
- **Unverified**: this environment has no `flutter` CLI, so none of this has been run, analyzed, or tested. The IDE's own Dart analyzer caught and helped fix one issue (unused imports) during writing, but a full `flutter analyze` / `flutter test` / `flutter run` pass still needs to happen locally before trusting this compiles and behaves as intended.
