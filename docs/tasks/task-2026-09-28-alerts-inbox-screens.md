# Task: Notifications/Inbox, Alerts, Alert detail screens

**Completed:** 2026-09-28

## What was built
The rest of the Dashboard branch from NAVIGATION_MAP.md's route table, completing the chain that starts at Dashboard's bell icon and "Triage N alerts" button:
- **Inbox** (`/dashboard/inbox`) — segmented toggle between "Needs attention" (top 3 alerts) and "Unresolved issues" (Sentry-style issue list); "All alerts →" link to the full list.
- **Alerts** (`/dashboard/alerts`) — filter chip row (only "All" is functional; Critical/Warning/Muted are visual-only for now, no underlying filter logic) + full alert card list.
- **Alert detail** (`/dashboard/alerts/:alertId`) — colored summary panel, metrics grid, a trace/log console (dark background regardless of app theme, matching the design's own code-block styling), primary CTA, and a snooze/un-snooze toggle.

Exact mock content (alert titles/details/metrics/trace lines, issue messages) was copied from `design-reference/DataCom Calm.dc.html` (grepped and read directly rather than reconstructed from memory) to keep it faithful.

## Files touched
- `lib/models/status_level.dart` (new) — `StatusLevel` enum extracted out of `dashboard_models.dart` since a second feature (alerts) now needs it too
- `lib/models/alert_models.dart` (new) — `Alert`, `Issue`, `AlertMetric`, `TraceLine`/`TraceEmphasis`
- `lib/services/alerts_repository.dart` (new) — `AlertsRepository` + `MockAlertsRepository`
- `lib/providers/alerts_providers.dart` (new) — list providers + an `alertByIdProvider` family provider for the detail screen
- `lib/screens/inbox_screen.dart`, `lib/screens/alerts_screen.dart`, `lib/screens/alert_detail_screen.dart` (new)
- `lib/widgets/datacom_card.dart`, `lib/widgets/status_badge.dart` (new) — extracted from Dashboard's private `_Card`/`_statusColor` now that a second screen needs the same card style and severity color logic
- `lib/theme/app_theme.dart` — `statusColor()` moved here from being private to `dashboard_screen.dart`, now shared
- `lib/screens/dashboard_screen.dart` — updated to use the now-shared `DataComCard`/`statusColor`; bell icon and "Triage" button now actually navigate instead of being no-ops
- `lib/router/app_router.dart` — nested routes added under `/dashboard`
- `assets/lang/en-US.json`, `assets/lang/ru-RU.json` — all new UI-chrome strings in both locales

## Notes / follow-ups
- Caught and fixed my own mistake mid-task: initially derived severity badge text from the `StatusLevel` enum name (`warn` → "WARN"), which doesn't match the design's actual text ("WARNING"), and hardcoded "ERROR" on every issue badge regardless of its real level. Fixed by adding an explicit `levelLabel` field to `Alert`/`Issue` instead of deriving display text from the enum (the enum stays purely for color mapping).
- Alert detail's primary CTA ("Open orders-primary" etc.) doesn't navigate anywhere yet — it shows a "Coming soon" toast, since the target screens (Database/Redis/Monitor detail) aren't built. Same for the Alerts screen's Critical/Warning/Muted filter chips — visual only.
- **Still unverified**: no `flutter analyze`/`test`/`run` executed (no Flutter CLI in this environment). The IDE's inline Dart diagnostics caught several real mistakes during writing (unused imports, and importantly a missing constructor field when I added `levelLabel` without also declaring it) — but that's not a substitute for a full local run.
