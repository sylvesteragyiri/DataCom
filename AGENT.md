# AGENT.md

This file is the entry point for any AI model/agent (Claude, GPT, Gemini, Copilot, etc.) working on the **DataCom** project. Read this before making changes.

## Project summary

- **Name:** DataCom
- **Platform:** Mobile app, targeting **iOS and Android** from a single codebase
- **Framework:** Flutter (Dart)
- **Origin:** UI/UX is being ported from a Claude design project ("DataCom Calm") — see [docs/ROADMAP.md](docs/ROADMAP.md) for import status
- **Status:** Flutter project scaffolded (`flutter create` default template, package id `com.datacom.datacom`) — no feature/screen code written yet
- **License:** [LICENSE](LICENSE) — © Sylvester Agyiri, all rights reserved. Free for non-commercial use; commercial use requires his prior written permission. Terms may change — the version distributed with a given copy of the repo is the one that applies.

## Source design

The visual design was imported from the Claude design project **"DataCom prototype"** and is saved locally under [design-reference/](design-reference/):
- `design-reference/DataCom Calm.dc.html` — the actual screens, layout, and state/data logic (the source of truth for what to build)
- `design-reference/android-frame.jsx` — a Claude Design preview harness only (renders an Android device bezel so the prototype previews correctly). Not a product requirement — ignore its Android-only framing.
- `design-reference/support.js` — Claude Design's own runtime for rendering `.dc.html` files. Not part of the Flutter app.

These are design references only. They are **not** part of the Flutter codebase and must be translated into Dart/Flutter widgets, not copied as-is. Read [docs/DESIGN_SUMMARY.md](docs/DESIGN_SUMMARY.md) first — it translates the raw `.dc.html` into a screen inventory, data model, and navigation model in product terms.

## Documentation map

- [docs/ROADMAP.md](docs/ROADMAP.md) — phases, current status, next steps
- [docs/DESIGN_SUMMARY.md](docs/DESIGN_SUMMARY.md) — screen inventory, navigation model, data model, and open product questions distilled from the design
- [docs/NAVIGATION_MAP.md](docs/NAVIGATION_MAP.md) — proposed Flutter route table and default architecture (Riverpod + go_router), pending sign-off before Phase 2
- [docs/FOLDER_STRUCTURE.md](docs/FOLDER_STRUCTURE.md) — repo/project layout
- [docs/PLAY_STORE_CHECKLIST.md](docs/PLAY_STORE_CHECKLIST.md) — everything Google Play requires to publish the app (store listing, assets, legal, technical, release)
- [docs/sessions/](docs/sessions/) — one file per work session (what was done, decisions made, open questions)
- [docs/tasks/](docs/tasks/) — one file per completed task/feature, written after the task is done

## Rules for AI agents working in this repo

1. **Do not write feature/screen application code until the user explicitly says to proceed.** Documentation and planning come first.
2. Before starting new work, read the most recent file in `docs/sessions/` to pick up context.
3. After a work session, add a new file to `docs/sessions/` summarizing what happened (see that folder's README for the template).
4. When a task/feature is finished, add a new file to `docs/tasks/` documenting what was completed (see that folder's README for the template).
5. Keep [docs/ROADMAP.md](docs/ROADMAP.md) up to date as phases complete or scope changes.
6. Keep [docs/FOLDER_STRUCTURE.md](docs/FOLDER_STRUCTURE.md) up to date as the layout changes.
7. Do not invent scope beyond what the user has asked for. Confirm before large architectural decisions (state management approach, backend/API choices, package selection, etc.).
8. No unnecessary comments in code. Only comment a non-obvious constraint, invariant, or workaround — never restate what the code already says.
9. **Build for swappability, not for any specific vendor.** State management, local persistence/DB, and any external service (example only, not a decision: Firebase) must sit behind an interface the rest of the app depends on — never call a vendor SDK directly from a screen or provider. See "Swappability principle" in [docs/NAVIGATION_MAP.md](docs/NAVIGATION_MAP.md). This does not mean add abstractions for things with no second implementation yet — one interface, one implementation, until a second one is actually needed.
