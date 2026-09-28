# Task: Database, Table, Redis, Bucket, Vercel, Keys & Key detail screens

**Completed:** 2026-09-28

## What was built
User asked for a batch of screens to be built while away, targeting "like 5 pages." Delivered 7 screens (Database detail's Schema tab needed Table detail to not be a dead end, and Keys naturally splits into a list + detail screen) — every remaining "Coming soon" stub on the Services and Settings screens is now resolved except the Cloudflare cloud card and Laravel Cloud card:

- **Database detail** (`/services/db/:connId`) — 4 tabs: Health (connection-pool banner, 6-metric grid, running queries), Queries (4 slow queries with expandable EXPLAIN ANALYZE plans + tuning hints), Schema (6-table list → Table detail), SQL (snippet chips, console-style query display, Run → result cards).
- **Table detail** (`/services/db/:connId/table/:tableName`) — 3 tabs: Columns (PK/FK/IDX badges), Indexes (usage stats), Rows (sample rows as key-value cards).
- **Redis detail** (`/services/redis/:connId`) — 3 tabs: Health (memory gauge, 6-metric grid, replication), Keys (TTL list), Slow log.
- **Bucket detail** (`/services/storage/:bucketId`) — breadcrumb + object list, tap → the existing `showDataComSheet` (preview/info/download/delete).
- **Vercel detail** (`/services/cloud/vercel/:connId`) — deployment list + build log console.
- **Keys & credentials** (`/settings/keys`) — masked credential list.
- **Key detail** (`/settings/keys/:credId`) — reveal/hide secret, Verify (simulated), Save, Delete.

Every connection card on the Services screen now routes to the right detail screen based on a new `ConnectionKind` field (`database`/`redis`/`storage`) rather than guessing from the group name string. The Vercel cloud card routes to its detail screen; Cloudflare and Laravel Cloud still show "Coming soon" (Cloudflare is a real future screen; Laravel Cloud was never actually implemented in the source design either — see the roadmap note).

Pulled **two shared widgets** out proactively, before a third screen could duplicate them again: `DataComSegmentedTabs` (the in-page tab pill switcher — Redis, Database, and Table all needed it) and `DataComConsole` (the dark monospace log/trace viewer — Alert detail already had a private copy, Database's EXPLAIN plans and Vercel's build log both needed the same thing). Refactored `alert_detail_screen.dart` to use the shared console instead of keeping its now-duplicate private one, and moved `TraceEmphasis` into a new shared `ConsoleEmphasis` enum (`lib/models/console_emphasis.dart`) so the model layer and the widget could agree on emphasis levels without the model importing Flutter.

## Files touched
Nine new model files, eight new repository files (all following the established `AbstractRepository` + `MockXRepository` swappability pattern), eight new provider files, and nine new/changed screen files. Full list in `lib/`:
- Models: `console_emphasis.dart`, `database_models.dart`, `redis_models.dart`, `storage_models.dart`, `vercel_models.dart`, `credential_models.dart`; edited `alert_models.dart`, `service_models.dart` (added `ConnectionKind`)
- Services: `database_repository.dart`, `redis_repository.dart`, `storage_repository.dart`, `vercel_repository.dart`, `credentials_repository.dart`; edited `services_repository.dart` (added `kind:` to every connection), `alerts_repository.dart` (renamed `TraceEmphasis` → `ConsoleEmphasis`)
- Providers: `database_providers.dart`, `redis_providers.dart`, `storage_providers.dart`, `vercel_providers.dart`, `credentials_providers.dart`
- Screens: `database_detail_screen.dart`, `table_detail_screen.dart`, `redis_detail_screen.dart`, `bucket_detail_screen.dart`, `vercel_detail_screen.dart`, `keys_screen.dart`, `key_detail_screen.dart`; edited `alert_detail_screen.dart` (dropped its private `_TraceConsole`), `services_screen.dart` (routing by `kind`, Vercel card routing), `settings_screen.dart` (Keys row routing)
- Widgets: `datacom_segmented_tabs.dart`, `datacom_console.dart` (new)
- Router: `lib/router/app_router.dart` — 7 new routes, all nested under `/services` or `/settings`

All mock data was pulled directly from `design-reference/DataCom Calm.dc.html` (re-read the exact lines before writing each repository, not reconstructed from memory) — connection pool numbers, all 4 slow-query EXPLAIN plans and hints verbatim, the 6 database tables, columns/indexes/rows for the `orders` table, Redis metrics/keys/slowlog, the 4 Vercel deployments and full build log, and all 6 credentials with their real masked/secret/scope values.

## Notes / follow-ups
- SQL tab is simplified versus the design: no query-history sheet, no cards/table result-view toggle (always shows cards). Documented as a deliberate scope cut, not an oversight.
- Key detail's AppBar title is a static "Credential" rather than the design's per-credential dynamic title (e.g. "Cloudflare API token") — a minor fidelity gap, not wired to `credential.name` because the title needs to come from the loading `AsyncValue` and `DataComAppBar`'s title is currently a fixed constructor param, not data-driven. Cheap to fix later.
- Cloudflare detail (Zones/Workers/Security tabs) is the one genuinely remaining screen from the original 18. Recommend building it next if screens continue.
- **Still completely unverified against a real Flutter toolchain.** This is now 15 screens, ~25 new files in one extended session, built entirely on IDE inline diagnostics (which caught real errors: missing imports, type mismatches, unused fields/vars) but never a full `flutter analyze`, `flutter test`, or `flutter run`. Strongly recommend a real run before this grows further — inline diagnostics do not catch logic bugs (the bottom-nav centering issue from the prior session is proof of that).
