# Task: Services screen (root tab)

**Completed:** 2026-09-28

## What was built
The Services root tab (`/services`): grouped connection list (Databases / Redis / Object storage — status dot, latency, overflow-menu button per connection) and a "Cloud & platforms" section (Cloudflare/Vercel/Laravel Cloud cards with mini stats). FAB ("+ Connection") in the corner.

New shared primitive: `showDataComSheet()` — a bottom-sheet action menu matching the design's global `sheet` overlay pattern, first used here for each connection's overflow menu (refresh/pin/edit/remove), reusable by any future screen that needs the same pattern (Object storage bucket rows do, per the design).

## Files touched
- `lib/models/service_models.dart` (new) — `ConnectionItem`, `ConnectionGroup`, `CloudCard`, `CloudStat`
- `lib/services/services_repository.dart` (new) — `ServicesRepository` + `MockServicesRepository`, exact mock data from `design-reference/DataCom Calm.dc.html`
- `lib/providers/services_providers.dart` (new)
- `lib/screens/services_screen.dart` (new)
- `lib/widgets/datacom_sheet.dart` (new)
- `lib/router/app_router.dart` — `/services` now builds `ServicesScreen`
- `assets/lang/en-US.json`, `assets/lang/ru-RU.json` — new keys

## Notes / follow-ups
- Caught and fixed a real layout bug myself before it shipped: initially used `DataComCard` (which forces `width: double.infinity`) for the small overflow-menu button, unwrapped by `Expanded`, inside a `Row` — that throws a "BoxConstraints forces an infinite width" layout error at runtime. Replaced with a properly sized `Material`+`InkWell` button instead. Worth remembering: `DataComCard` is only safe as a `Row` child when wrapped in `Expanded`.
- Tapping a connection, a cloud card, or the FAB all show a "Coming soon" toast — the screens they'd actually navigate to (Add connection flow, Database/Redis/Storage/Cloudflare/Vercel detail) don't exist yet.
- Also fixed, incidentally: `dashboard_repository.dart` was missing an explicit import for `status_level.dart` (it uses `StatusLevel.ok` etc. directly, and Dart imports aren't transitive) — this surfaced as a disk change from what looks like an IDE auto-fix using a `package:datacom/...` absolute import; normalized it to the relative-import style used everywhere else in the codebase.
- **Still unverified**: no `flutter analyze`/`test`/`run` locally.
