# Task: Replace docked NavigationBar with the design's floating icon-only pill

**Completed:** 2026-09-28

## What was built
The bottom nav was originally built with Flutter's standard `NavigationBar` — full-width, docked, with text labels under each icon. The user flagged this doesn't match the design at all and asked for it to be checked against the design system again. It didn't: `design-reference/DataCom Calm.dc.html` (lines 877–884, 1227–1236, 1479–1480) specifies a **floating, pill-shaped, icon-only** bar — `width:max-content` (auto-sized, not full width), centered, `border-radius:100px`, floating 16px above the bottom edge with a soft shadow, 38px circular buttons, labels only ever used as `aria-label`/`title` (never rendered as visible text).

Rebuilt as `DataComBottomNav`:
- Container sized to content (`Row(mainAxisSize: MainAxisSize.min)`), pill-shaped, outlined, drop shadow, centered via `Scaffold.bottomNavigationBar` → `Center` (rather than docked full-width) with `Scaffold(extendBody: true)` so screen content can scroll behind the floating pill.
- Icons are **custom-painted from the design's exact SVG path data**, not substituted Material icons — parsed the three `d="..."` path strings by hand (home: roofline + rounded-corner walls including two elliptical arc segments; services: two stacked rectangles with small status dots, i.e. server racks; settings: two slider tracks with knob ticks) and redrew them with `CustomPainter`/`Path.arcToPoint` at the same `viewBox 0 0 24`, `stroke-width 1.8`, round caps/joins as the original.
- Selected tab: filled primary-color circle + `onPrimary` icon. Unselected: transparent + muted icon color. Small red badge dot on Home and Services (matches the design's `badge: '3'`/`'2'` on those two, none on Settings) — not wired to a real unread count yet, just visual parity.
- Accessibility labels preserved via `Tooltip` + `Semantics(label: ...)`, translated, even though nothing is visibly rendered as text — mirrors the design's own `aria-label`/`title` attributes.

## Files touched
- `lib/widgets/datacom_bottom_nav.dart` (new)
- `lib/router/app_router.dart` — `AppShell` now uses `DataComBottomNav` instead of `NavigationBar`; `Scaffold(extendBody: true)`
- `lib/screens/dashboard_screen.dart`, `inbox_screen.dart`, `alerts_screen.dart`, `alert_detail_screen.dart`, `settings_screen.dart` — bottom content padding raised from 24 to 96 so scrollable content doesn't end up hidden under the now-floating (not docked) nav. `services_screen.dart` already had 96 (for its FAB) so needed no change.
- `test/widget_test.dart` — the old test asserted on visible label text (`find.text('Home')` etc.), which no longer exists now that the bar is icon-only. Rewrote it to use `find.bySemanticsLabel(...)` instead (via `tester.ensureSemantics()`), which is actually the more correct check for an icon-only, accessibility-labeled control.

## Update (same day)
User asked to move the nav to the bottom and make it "stick" — read as: drop the 16px floating gap and dock the pill flush against the bottom safe-area edge (the design's own `navFloating:false` mode, `navBottom: 0`, as opposed to the `navFloating:true` default I'd built). `AppShell` in `lib/router/app_router.dart` no longer wraps the pill in `Padding(bottom: 16)` — just `SafeArea(top: false)` + `Center`, so it sits right at the bottom edge (still pinned via `Scaffold.bottomNavigationBar`, still pill-shaped/icon-only, just no gap underneath it now). Left screens' bottom content padding (96) unchanged — still a safe amount of clearance, no need to shave it down for a ~16px difference.

## Notes / follow-ups
- Caught this myself while building: switching to a floating nav with `extendBody: true` means every screen's scrollable content can now be obscured by the pill unless it reserves bottom space — audited and fixed all 6 screens' bottom padding rather than just the nav widget itself.
- Badge dots (Home/Services) are still hardcoded `true`/`true`/`false`, not driven by real unread counts — same simplification as everywhere else mock data hasn't been replaced yet.
- **Still unverified** locally — no `flutter analyze`/`test`/`run`. This change in particular (hand-translated SVG arc math) is the kind of thing worth actually looking at on a device/simulator rather than trusting blind, more than most of the other changes this session.
