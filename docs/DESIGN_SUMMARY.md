# Design Summary — "DataCom Calm" prototype

Source: Claude Design project **"DataCom prototype"** (`c3ce9abc-da8e-484c-9c25-4ddba84e9ff6`), file `DataCom Calm.dc.html`, imported and saved locally under [`design-reference/`](../design-reference/) on 2026-09-28. This document translates that prototype into product/screen terms so it can be planned and built as a Flutter app. It is a **summary for planning**, not a spec — always check `design-reference/DataCom Calm.dc.html` for exact copy, states, and mock data before implementing a screen.

## Product concept

DataCom is a **local-first, no-account** mobile app for monitoring your own infrastructure — databases, caches, object storage, and cloud/observability platforms — from your phone. Two product principles are explicit in the prototype's own copy:

- **"Local-first · no account"** — no DataCom-owned backend; the footer literally says this.
- **Read-only by design** — "DataCom only ever issues read requests" (shown on the credential scope field). It monitors; it does not mutate infrastructure.
- **On-device credential storage** — "Secrets are encrypted with the Android keystore and never leave this device." On Flutter this means `flutter_secure_storage` (Android Keystore-backed) on Android and Keychain-backed on iOS — no server-side credential storage.

## Navigation model

- Bottom pill nav with **3 root tabs**: **Dashboard**, **Services** (labelled "infra" internally), **Settings**.
- Each root keeps its own back-stack (`push(screen)` / `back()`); switching tabs resets that tab to its root screen.
- Overlay patterns: a bottom **sheet** (contextual menus — refresh/pin/edit/remove, delete confirmations), a **toast** (transient confirmations, e.g. "Refreshed X"), and a **FAB** ("+ Connection", shown only on the Services tab).
- Theme: light/dark toggle, persisted in app state (not yet wired to system theme in the prototype).

## Screen inventory

| # | Screen | Notes |
|---|--------|-------|
| 1 | **Dashboard** (root) | Critical-alert banner with CTA → Alerts; 4-up health tiles (connected/healthy/warning/critical); "Average latency" line chart (p50/p95/throughput); "Live metrics" grid; "Activity" timeline |
| 2 | **Notifications / Inbox** | Tabs: "Needs attention" (alerts) / "Unresolved issues" (Sentry-style) |
| 3 | **Alerts** (list) | Filter chips (All/Critical/Warning/Muted); alert cards |
| 4 | **Alert detail** | Level/age header, metrics grid, trace/log viewer, primary CTA ("Open <service>"), snooze/ack |
| 5 | **Services** (root, "infra") | Grouped connection list (Databases / Redis / Object storage) — status dot, latency, overflow menu; "Cloud & platforms" cards (Cloudflare/Vercel/Laravel Cloud); FAB to add a connection |
| 6 | **Add connection — type picker** | Grouped grid: Databases / Cache & storage / Cloud & observability |
| 7 | **Add connection — form** | Dynamic fields (name/host/port/db/user/password), TLS toggle, test connection, save |
| 8 | **Database detail** | Tabs: Health (pool usage, metrics, running queries) / Queries (slow query log, expandable EXPLAIN ANALYZE + hint) / Schema (table list) / SQL (console: snippets, run, results as cards or table) |
| 9 | **Table detail** | Tabs: Columns (name/type/PK-FK-IDX badge) / Indexes (definition + usage) / Rows (sample rows as key-value cards) |
| 10 | **Redis detail** | Tabs: Health (memory gauge, metrics, replication) / Keys (search + TTL list) / Slowlog |
| 11 | **Object storage** (list) | Buckets: provider, region, size, object count |
| 12 | **Bucket detail** | Breadcrumb path + object list; tap → sheet (preview/info/download/delete) |
| 13 | **Vercel detail** | Deployments list (sha/state/branch) + build log console |
| 14 | **Cloudflare detail** | Tabs: Overview (metrics, zones, DNS) / Workers (worker cards + logs) / Security (blocked requests, event log) |
| 15 | **Monitor (Sentry-style)** | Metrics + unresolved issues list (issue list is also duplicated inline in Inbox's "issues" tab) |
| 16 | **Settings** (root) | Dark theme toggle; grouped sections: Connections, Credentials, Monitoring, Data; version footer |
| 17 | **Keys & credentials** (list) | Stored secrets, masked; on-device encryption notice |
| 18 | **Key detail / form** | View/edit one credential: label, secret (mask/reveal), scope, verify, save, delete |

## Settings sections (from the prototype)

- **Connections** — Manage connections (→ Services), Add a connection, Import/export (encrypted JSON file, on-device)
- **Credentials** — Keys & credentials, App lock (biometric, "handled by the system keystore")
- **Monitoring** — Refresh interval (default 30s), Alert thresholds (per-service warn/critical), Slow query threshold (default 500ms)
- **Data** — Cached responses (offline cache size + clear), Wipe local data (destructive, confirmed via sheet)

## Data model hints (from mock data in the script)

- **Connection**: `name`, `host`, `type` (postgres/mysql/mariadb/sqlite/mssql/redis/s3/r2/minio/spaces), `status` (ok/warn/crit), `latency`
- **Credential**: `name`, `provider`, `field` (label), `state` (SET/MISSING), `masked`, `secret`, `scope`
- **Alert**: `level`, `title`, `detail`, `source`, `ago`, `target` (screen to deep-link into), `metrics[]`, `trace[]` (log/explain lines)
- **Table**: `name`, row/column/index counts, `size`; **Column**: `name`, `type`, `badge` (PK/FK/IDX); **Index**: `name`, `def`, usage stat
- **Deployment** (Vercel): `sha`, `state`, `msg`, `branch`, `dur`, `ago`

Connector types the type-picker offers: **Databases** — PostgreSQL, MySQL, MariaDB, SQLite, SQL Server. **Cache & storage** — Redis, AWS S3, Cloudflare R2, MinIO, DO Spaces. **Cloud & observability** — Cloudflare, Vercel, Laravel Cloud, Nightwatch, Sentry.

## Visual language

- **Fonts**: Instrument Sans (UI text), IBM Plex Mono (numeric/technical/code, tabular figures)
- **Color tokens (light)**: bg `#eef1f8`, surfaces `#ffffff`/`#e7ebf5`/`#f7f9fd`, text `#111528`/`#767d94`, primary `#2f5bea`, ok `#12805c`, warn `#a5620a`, critical `#d13b41` — a parallel dark palette is also defined in the script (`DARK` object)
- Rounded cards (16–18px radius), soft layered shadows, small status dots, monospace numeric badges
- Consistent status semantics throughout: ok (green) / warn (amber) / crit (red) / info (blue/primary), always paired with a light "chip" background

## Platform note

The prototype is wrapped in an **Android Material 3 device frame** (`android-frame.jsx`) purely so it previews correctly inside Claude Design — this is a preview harness only, not a product requirement to be Android-only. The actual app ships on **iOS and Android via Flutter**; a decision is needed on whether to use a single custom design system across both platforms (recommended, given how custom this UI already is) or lean on `Material`/`Cupertino` adaptive widgets per platform.

## Decisions (2026-09-28)

- **Backend scope**: build Phase 1–2 fully local-first, exactly as designed (no backend). Keep the data/repository layer backend-friendly (abstract interfaces, not hardcoded to local-only) so a minimal backend can be added later for push notifications/sync without a rewrite. See [NAVIGATION_MAP.md](NAVIGATION_MAP.md) for how this shapes the app's layering.
- **Network reachability** (phone → internal infra like `10.0.4.11:5432`): not resolved yet — proceed assuming direct reachability (VPN/same-network) for UI/app development, and revisit before release. Do not build a relay/agent component now.

## Open items before implementation

- Real data-source integrations per connector type (Postgres/MySQL/MariaDB/SQLite/SQL Server, Redis, S3-compatible stores, Cloudflare, Vercel, Laravel Cloud, Nightwatch, Sentry) — the prototype uses static mock data only, nothing here is a working client.
- Secure local credential storage on both platforms (`flutter_secure_storage` or equivalent).
- Background/foreground refresh strategy for the stated "refresh interval" setting (default 30s) — mobile OS background execution limits apply on both platforms, and get stricter with no backend to hand polling off to.
- Direct network access to internal infrastructure — revisit before release (see Decisions above).
