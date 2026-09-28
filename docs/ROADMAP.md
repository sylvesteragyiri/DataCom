# Roadmap

Status legend: `[ ]` not started · `[~]` in progress · `[x]` done

## Phase 0 — Documentation & setup
- [x] Create documentation structure (`docs/`, `AGENT.md`, sessions/tasks folders)
- [x] Import the "DataCom Calm" design (`DataCom Calm.dc.html`, `android-frame.jsx`, `support.js`) — saved to [`design-reference/`](../design-reference/) via the DesignSync tool after `/design-login`
- [x] Decide Flutter project structure and state management approach — Riverpod + go_router, see [NAVIGATION_MAP.md](NAVIGATION_MAP.md) (pending your sign-off)
- [x] Decide on backend/data needs — local-first for now, backend-friendly repository layer for later; see Decisions in [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md)
- [x] Initialize git repository
- [x] Add [LICENSE](../LICENSE) — © Sylvester Agyiri, free for non-commercial use, commercial use requires permission; terms subject to change

## Phase 1 — Design review
- [x] Read through the full design file and catalog every screen — see [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md)
- [x] Catalog screens/components implied by the design (18 screens across 3 root tabs)
- [x] Note platform-specific considerations — the `android-frame.jsx` is a Claude Design preview harness only, not an Android-only requirement; app ships on iOS + Android via Flutter
- [x] Translate design intent into a Flutter screen/navigation map — see [NAVIGATION_MAP.md](NAVIGATION_MAP.md)
- [x] Resolve open questions enough to proceed — local-first/no-backend and network-reachability decisions recorded in [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md)

## Phase 2 — Flutter project scaffold
- [x] `flutter create` the app with iOS + Android targets (package id `com.datacom.datacom`) — default template only, no feature code
- [x] Localization folder seeded — `assets/lang/en-US.json`, `assets/lang/ru-RU.json`, registered in `pubspec.yaml`; see Localization in [NAVIGATION_MAP.md](NAVIGATION_MAP.md)
- [x] Add Riverpod, go_router, flutter_secure_storage, easy_localization to `pubspec.yaml` (per [NAVIGATION_MAP.md](NAVIGATION_MAP.md)) — **run `flutter pub get` locally to resolve/lock versions**, this environment has no Flutter CLI on PATH to verify them
- [x] Set up folder conventions — `lib/screens/`, `lib/router/`, `lib/theme/` created; `widgets/`, `models/`, `services/` will be added when their first real file is needed (linting: default `flutter_lints` from `flutter create`, untouched)
- [x] Set up basic app shell/navigation — `lib/router/app_router.dart` (go_router `StatefulShellRoute`, 3 tabs) + `lib/theme/app_theme.dart` (light/dark theme from the design's color tokens) + `lib/main.dart` wired up with EasyLocalization/Riverpod/go_router. Placeholder screens only — real screen content is Phase 3.

## Phase 3 — Implementation
- [x] Add `lib/widgets/`, `lib/models/`, `lib/services/`, `lib/providers/` — created for the Dashboard screen, see [docs/tasks/](tasks/)
- [~] Build screens per the design, one at a time — **Dashboard done** (critical banner, health tiles, latency chart, live metrics, activity feed); Notifications/Inbox, Alerts, Alert detail, Services, and the rest of the 18-screen inventory in [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md) remain
- [~] Wire up state management — Riverpod pattern established (repository → provider → `ConsumerWidget`), repeats per screen
- [ ] Wire up any real data/backend integration — still mock data (`MockDashboardRepository`); real connectors are a separate, larger effort

## Phase 4 — Testing & polish
- [ ] Widget/unit tests for core logic
- [ ] Manual test pass on iOS simulator and Android emulator
- [ ] Accessibility pass

## Phase 5 — Release prep
- [ ] iOS App Store metadata/build
- [ ] Android Play Store — see [PLAY_STORE_CHECKLIST.md](PLAY_STORE_CHECKLIST.md) for the full requirement list (store listing, graphic assets, privacy policy, data safety, signing, testing tracks)

**Note:** the Play Store checklist doesn't depend on app code except for the final signed build and screenshots — developer account setup, store listing copy, graphic assets, and the privacy policy can be worked on any time, including before Phase 3 implementation finishes.

## Backlog (later, not now)
- **GitHub Actions CI workflow** — not started, deliberately deferred. When picked up, `.github/workflows/ci.yml` should at minimum: run on push/PR to `main`, `flutter pub get`, `flutter analyze`, `flutter test`. Consider adding a build-check job (`flutter build apk`, `flutter build ios --no-codesign`) to catch platform build breakage early. Release automation (signed builds, upload to Play Console) is a separate, later step — don't build that until Phase 5 is actually underway.

## Notes / open questions
- Design import: resolved by running `/design-login` in an interactive Claude Code session, then pulling the project's files directly via the DesignSync tool. Source files now live in [`design-reference/`](../design-reference/); see [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md) for the translated screen inventory and open product questions.
- Riverpod/go_router in [NAVIGATION_MAP.md](NAVIGATION_MAP.md) is still a proposal awaiting sign-off, not a final decision.
