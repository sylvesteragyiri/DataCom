# Session: Design import

**Date:** 2026-09-28

## What happened
- Set up the documentation structure (`AGENT.md`, `docs/ROADMAP.md`, `docs/FOLDER_STRUCTURE.md`, `docs/sessions/`, `docs/tasks/`) — no code written.
- Attempted to import the "DataCom Calm" Claude Design project via the DesignSync tool; it initially failed because this non-interactive session had no design-system authorization.
- User ran `/design-login` in an interactive Claude Code session on this machine to authorize design-system access.
- Retried and successfully pulled the project ("DataCom prototype", id `c3ce9abc-da8e-484c-9c25-4ddba84e9ff6`, type `PROJECT_TYPE_PROJECT` — not a design-system project, but read access worked anyway).
- Saved `DataCom Calm.dc.html`, `android-frame.jsx`, and `support.js` locally to `design-reference/`.
- Read the full `.dc.html` file (screens, navigation logic, mock data, color/typography tokens) and wrote up [docs/DESIGN_SUMMARY.md](../DESIGN_SUMMARY.md) — an 18-screen inventory, navigation model, data model hints, and open product questions.
- Updated `docs/ROADMAP.md` (Phase 0/1 marked complete for import + review) and `AGENT.md` (pointed at the new design reference and summary).

## Decisions made
- Design source files are kept in a top-level `design-reference/` folder (not under `docs/`), since they're raw source material referenced by docs rather than documentation themselves.
- Treat `android-frame.jsx` as a Claude Design preview harness only — it does not mean the app should be Android-only or use that specific Material 3 styling; the app targets both iOS and Android via Flutter.

## Open questions / follow-ups
- See "Open items before implementation" in [DESIGN_SUMMARY.md](../DESIGN_SUMMARY.md) — notably whether "local-first, no backend" is a hard constraint (it affects sync, background alerts/push notifications, and whether direct connections to internal infra IPs are even reachable from a phone).
- The two reference `.webp` images in the design project's `uploads/` folder were not pulled (not needed for screen logic) — fetch them later only if they turn out to matter (e.g. app icon/marketing assets).
- Still not started: Flutter project scaffold, state management choice, and translating the screen inventory into actual routes/widgets (per the roadmap, code should not start until the user says to proceed).
