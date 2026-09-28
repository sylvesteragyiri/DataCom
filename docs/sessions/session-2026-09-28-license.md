# Session: Add LICENSE

**Date:** 2026-09-28

## What happened
- Added a custom `LICENSE` file at the repo root rather than picking a pre-existing OSS license (MIT/Apache/etc. are permissive and would allow commercial use, which contradicts the requirement).
- Terms: © Sylvester Agyiri, all rights reserved / ownership retained; free to use, copy, modify, and distribute for non-commercial purposes; commercial use requires his prior written permission; standard no-warranty clause; explicit note that terms may change and the version shipped with a given copy is the one that applies; explicit carve-out that Flutter/Dart and pub.dev dependencies remain under their own separate licenses (this file only covers Sylvester's own code and assets).
- Linked it from `README.md` and noted it in `AGENT.md` and `ROADMAP.md`.

## Decisions made
- Wrote a custom license rather than adopting a named standard one (e.g. PolyForm Noncommercial), since the user's terms are specific and explicitly "subject to change" — a custom short document is easier to revise than adapting formal license text. Worth reconsidering a standard license later if this needs to hold up legally at scale.

## Open questions / follow-ups
- This is not legal advice/review — if this license needs to be enforceable (e.g. against a real commercial infringer), it's worth having an actual lawyer review or formalize it, possibly starting from PolyForm Noncommercial 1.0.0 which covers the same "free non-commercial / commercial requires permission" intent with tested legal language.
- Scope currently covers everything in this repository (code, `design-reference/`, `assets/`) except third-party dependencies — confirm that's the intended scope, especially for `design-reference/`, which is derived from work done inside Claude Design.
