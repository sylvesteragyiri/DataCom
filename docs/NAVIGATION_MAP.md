# Flutter navigation & architecture map

Translates [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md)'s screen inventory into a concrete route table and picks a default technical approach for Phase 2. This is a first-pass mapping from a read of the design's `push()`/`tabTo()` calls — validate against `design-reference/DataCom Calm.dc.html` for any screen you're about to build, don't treat this table as gospel.

## Routing structure

The design uses **3 persistent root tabs, each with its own independent back-stack** (`tabTo` resets a tab to its root; `push`/`back` operate within the current tab). In Flutter, `go_router`'s `StatefulShellRoute` is built for exactly this pattern (bottom nav bar + per-branch navigation stack that's preserved when switching tabs), so that's the recommended router.

```
StatefulShellRoute (bottom nav: Dashboard / Services / Settings)
├─ Branch: Dashboard
│  ├─ /dashboard                        Dashboard (root)
│  ├─ /dashboard/inbox                  Notifications / Inbox (tabs: alerts, issues)
│  ├─ /dashboard/alerts                 Alerts (list, filterable)
│  └─ /dashboard/alerts/:alertId        Alert detail
│
├─ Branch: Services ("infra")
│  ├─ /services                         Services (root) — grouped connection list + cloud cards
│  ├─ /services/add                     Add connection — type picker
│  ├─ /services/add/form                Add connection — form (dynamic fields per type)
│  ├─ /services/db/:connId              Database detail (in-page tabs: Health/Queries/Schema/SQL)
│  ├─ /services/db/:connId/table/:name  Table detail (in-page tabs: Columns/Indexes/Rows)
│  ├─ /services/redis/:connId           Redis detail (in-page tabs: Health/Keys/Slowlog)
│  ├─ /services/storage                 Object storage (bucket list across accounts)
│  ├─ /services/storage/:bucketId       Bucket detail (object list)
│  ├─ /services/cloud/vercel/:connId    Vercel detail (deployments + build log)
│  ├─ /services/cloud/cf/:connId        Cloudflare detail (in-page tabs: Overview/Workers/Security)
│  └─ /services/monitor/:connId         Sentry-style monitor detail
│
└─ Branch: Settings
   ├─ /settings                         Settings (root) — grouped sections
   ├─ /settings/keys                    Keys & credentials (list)
   ├─ /settings/keys/new                New credential form
   └─ /settings/keys/:credId            Credential detail/edit form
```

Notes:
- Screens with in-page tabs (Database, Redis, Cloudflare, Table) keep the tab as local widget state, not a route param — matches the design (`dbTab`, `redisTab`, etc. live in component state, not the nav stack).
- The bottom sheet, toast, and add-connection FAB are overlays, not routes — implement with a modal bottom sheet widget, a snackbar/toast helper, and a `Scaffold.floatingActionButton` shown conditionally on the Services branch.

## Recommended architecture (default — revisit if it doesn't fit)

| Concern | Choice | Why |
|---|---|---|
| State management | **Riverpod** | Compile-safe DI, strong async support (needed for polling connections on an interval), easy to test repositories in isolation |
| Routing | **go_router** | Official Flutter team package; `StatefulShellRoute` matches the design's per-tab back-stack directly |
| Secure storage | **flutter_secure_storage** | Android Keystore-backed on Android, Keychain-backed on iOS — matches the design's stated on-device encryption promise |
| Data layer | **Repository pattern**, abstract interfaces (`ConnectionRepository`, `CredentialRepository`, `AlertRepository`, one per connector type) with local-only implementations for now | Per the backend decision in DESIGN_SUMMARY.md — keeps the door open to a future minimal backend (for push/sync) without rewriting the UI layer |
| Localization | JSON files in `assets/lang/` (`en-US.json`, `ru-RU.json`), loaded via **easy_localization** (proposed) | User decision: support multiple languages from the start, starting with English (en-US) and Russian (ru-RU); `easy_localization`'s default convention is exactly a JSON-per-locale assets folder |

This still needs your sign-off before Phase 2 (`flutter create` + actual code) starts — flag now if you'd rather use Bloc/Provider/GetX instead of Riverpod, or a different router.

## Swappability principle

No layer above should be hard-wired into the rest of the app such that replacing it means a rewrite. Concretely:

- **UI never talks to a vendor SDK directly.** Screens depend on repository interfaces (`ConnectionRepository`, etc.), never on a specific database driver, cloud SDK, or storage API. Swapping local SQLite for something else, or adding a synced backend, means writing a new implementation of the interface — not touching any screen.
- **State management is isolated behind providers/notifiers, not spread through widgets as raw vendor calls.** If Riverpod is ever swapped for something else, that should mean rewriting the provider layer, not every screen.
- **Local persistence (if/when a DB is introduced) sits behind a repository interface too**, same as any other data source — no screen or provider should import a database package directly.
- **New tools (example only — not a decision to add it: Firebase, or anything else) plug in as a new repository/service implementation**, not as a change scattered across the codebase. If it doesn't fit behind an existing interface, that's a sign the interface needs to grow, not that vendor code should leak into the UI.

This is a standing constraint on how Phase 3 implementation is structured, not a call to add abstractions nothing currently uses — one interface, one local implementation, is enough until a second implementation actually shows up.

## Localization

- **Locales at launch**: `en-US` (default/fallback), `ru-RU`.
- **Storage**: one JSON file per locale in `assets/lang/` (already created: `en-US.json`, `ru-RU.json`), registered as an asset folder in `pubspec.yaml`. Flat `"key": "value"` pairs, seeded for now with just `app_name` — real UI strings get added key-by-key as each screen from [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md) is actually built in Phase 3, not translated in bulk ahead of the screens existing.
- **Package**: `easy_localization` (proposed, not yet added to `pubspec.yaml` dependencies) — its default convention already matches a JSON-per-locale assets folder, so it fits this structure directly rather than requiring ARB files + codegen (Flutter's other standard approach, `flutter gen-l10n`). Flag now if you'd rather use that instead.
- **Swappability**: widgets should read strings through a single translation call (e.g. `context.tr('key')` via easy_localization), never format/branch on locale directly in a screen — if the i18n package changes later, only that call site's implementation changes.
