# Session: Architecture decisions & navigation map

**Date:** 2026-09-28

## What happened
- Asked the user to resolve the two open product questions from the design import: backend scope, and network reachability to internal infrastructure.
- Initialized the git repository (`git init`) and added a placeholder `.gitignore` (OS/editor cruft + Dart/Flutter build artifacts; `flutter create` will likely supersede this with a fuller one).
- Wrote [docs/NAVIGATION_MAP.md](../NAVIGATION_MAP.md): a route table translating the 18-screen inventory into a `go_router` `StatefulShellRoute` structure (3 tabs, each with its own back-stack, matching the design's `push`/`back`/`tabTo` model), plus a proposed default architecture (Riverpod, go_router, flutter_secure_storage, repository pattern with abstract interfaces).
- Updated ROADMAP.md (Phase 0 and Phase 1 now fully checked off) and DESIGN_SUMMARY.md (recorded the two decisions below) and AGENT.md (linked the new doc).

## Decisions made
- **Backend scope**: local-first for Phase 1–2, no backend built now — but the data/repository layer must be designed behind abstract interfaces so a minimal backend (for push notifications / cross-device sync) can be added later without rewriting the UI.
- **Network reachability** (phone → internal infra IPs): deferred. Proceed with app/UI development assuming direct reachability; revisit before release rather than building a relay/agent now.
- **Proposed (not yet confirmed) tech choices**: Riverpod for state management, go_router for routing, flutter_secure_storage for credentials. Flagged as a default in NAVIGATION_MAP.md, not a final decision — needs explicit sign-off before Phase 2 starts.

## Open questions / follow-ups
- User has not yet signed off on Riverpod/go_router specifically — confirm before running `flutter create` and wiring up routing.
- Network reachability question is deferred, not resolved — must be revisited before release messaging/marketing implies "just works," since it likely requires a VPN or a relay component.
- Next actionable step per the roadmap is Phase 2: `flutter create` with iOS + Android targets. Per AGENT.md rule #1, do not start this without the user explicitly saying to proceed with code.
