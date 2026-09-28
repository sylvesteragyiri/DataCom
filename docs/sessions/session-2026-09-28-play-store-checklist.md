# Session: Play Store checklist & no-comments rule

**Date:** 2026-09-28

## What happened
- Noticed the Flutter scaffold now exists in the repo (`lib/main.dart`, `pubspec.yaml`, `android/`, `ios/`, etc.) — default `flutter create` template, package id `com.datacom.datacom`, no feature code. This was created outside this session (not by me); updated AGENT.md, FOLDER_STRUCTURE.md, and ROADMAP.md Phase 2 to reflect it factually.
- Added rule 8 to AGENT.md: no unnecessary comments in code, only non-obvious rationale.
- Wrote [docs/PLAY_STORE_CHECKLIST.md](../PLAY_STORE_CHECKLIST.md): every category Google Play requires to publish the app — developer account, app identity, store listing copy, graphic assets, legal/compliance (privacy policy, data safety, content rating), technical/release requirements, testing tracks.
- Added this checklist to Phase 5 of the roadmap, and flagged that it can be worked on independently of / ahead of the Flutter implementation phases, per the user's request.

## Decisions made
- Play Store prep is not strictly sequential — it can be picked up any time before Phase 3 finishes, since only the final signed build and screenshots need working app code.

## Open questions / follow-ups
- Privacy policy content needs to be actually drafted and hosted somewhere reachable by a URL before submission — not just checklisted.
- Play's minimum target SDK and screenshot spec requirements change periodically; PLAY_STORE_CHECKLIST.md says to re-verify against the live Play Console before submitting rather than trusting the doc as final.
- Still waiting on user sign-off for Riverpod/go_router before adding those dependencies to `pubspec.yaml`.
