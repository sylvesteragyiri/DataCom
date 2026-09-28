# Session: Fix bottom nav to match the design

**Date:** 2026-09-28

## What happened
- User pointed out directly that the bottom nav didn't match the design ("check the design system again, the nav is float in the middle, no text") — a real correction, not a "continue". This was a genuine miss from the original Phase 2 app-shell session: I'd used Flutter's standard `NavigationBar` and documented it at the time as "visual polish for later" rather than actually checking the spec closely enough to notice it was fundamentally the wrong widget shape (docked/full-width/labeled vs. floating/pill/icon-only), not just a styling detail.
- Re-read the exact nav markup and script values in `design-reference/DataCom Calm.dc.html` before writing any code this time, rather than working from memory of "it's a floating nav bar" — pulled the literal CSS values (`width:max-content`, `border-radius:100px`, `16px` floating margin, `38px` button size) and the three icons' raw SVG `d=` path strings.
- Full details in [docs/tasks/task-2026-09-28-floating-nav-bar.md](../tasks/task-2026-09-28-floating-nav-bar.md).
- While implementing, caught that switching to a floating (non-docked) nav with `extendBody: true` would newly obscure scrollable content on every screen unless padding was adjusted — fixed all 6 screens, not just the nav widget.

## Decisions made
- Hand-translated the exact SVG path data into a `CustomPainter` rather than substituting close-looking Material icons — given the user explicitly asked to re-check fidelity against the design, approximating again with stand-in icons would risk repeating the same category of mistake.

## Open questions / follow-ups
- **Memory-worthy pattern**: when told to build "per the design," treat every visual claim (shape, position, sizing) as something to re-verify against the actual markup before writing code — don't rely on a prior summary/memory of what a component looks like, even one written earlier in the same project by the same session lineage. [DESIGN_SUMMARY.md](../DESIGN_SUMMARY.md) is a summary for planning, not a pixel spec — said exactly that when it was written, and this session is the reason why that caveat matters.
- Badge dots are still fake (not wired to a real inbox/service-update count).
- Standing caveat unchanged: no local Flutter toolchain run yet across the whole session.
