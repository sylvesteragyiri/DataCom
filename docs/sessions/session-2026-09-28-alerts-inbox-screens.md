# Session: Inbox/Alerts/Alert detail screens

**Date:** 2026-09-28

## What happened
- User said "continue" again (fifth time in a row, this time against `lib/main.dart` open in the IDE, no new instruction). Continued treating it as approval to keep advancing Phase 3.
- Chose to build the rest of the Dashboard branch (Inbox, Alerts, Alert detail) next rather than switching tabs to Services, since Dashboard already links to both (bell icon, "Triage" button) and they share the same underlying alert data — building them together avoided leaving those Dashboard buttons as dead-end no-ops.
- Full details of what was built are in [docs/tasks/task-2026-09-28-alerts-inbox-screens.md](../tasks/task-2026-09-28-alerts-inbox-screens.md).
- Mid-task, extracted `StatusLevel` out of `dashboard_models.dart` into its own `status_level.dart` file, and pulled `_Card`/`_statusColor` out of `dashboard_screen.dart` into shared `widgets/`/`theme/` — both were private to Dashboard but a second feature (alerts) needed the same things, matching the "extract on second use" rule already established for UI last session, now applied to models too.
- Made a real mistake and self-corrected: derived alert/issue severity badge text from the `StatusLevel` enum name instead of the design's actual copy, producing "WARN" instead of "WARNING" and hardcoding "ERROR" on every issue. The IDE's inline diagnostics didn't catch this (it's a logic/content bug, not a type error) — caught it myself by re-reading the design's original mock data before finishing. Fixed with an explicit `levelLabel` field.

## Decisions made
- Filter chips on the Alerts screen and the alert detail's CTA button are visual-only stubs for now (toast "Coming soon" / no filtering logic) rather than half-implemented — the target screens/filtering they'd need don't exist yet.

## Open questions / follow-ups
- Same standing caveat as every prior code session: nothing has been run through `flutter analyze`/`test`/`run` locally.
- Next screen choice still open — Services (root tab) is the next tab-level screen; alternatively continuing the Dashboard branch is now complete, so Services is the natural next step, but no explicit instruction has been given yet.
