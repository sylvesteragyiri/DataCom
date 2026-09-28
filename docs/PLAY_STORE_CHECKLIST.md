# Google Play — publishing checklist

Everything Google Play requires to list and host DataCom, so this can be worked on independently of the Flutter build phases. Status legend: `[ ]` not started · `[~]` in progress · `[x]` done.

## Developer account
- [ ] Google Play Console developer account created (one-time registration fee, identity verification)
- [ ] Developer name, support email, and (if organization) D-U-N-S/business verification completed

## App identity
- [x] Package name / application id chosen: `com.datacom.datacom` (set in `android/app/build.gradle.kts`) — **cannot be changed after first publish**, confirm before release
- [ ] App name for the store listing decided (may differ from internal project name "DataCom")
- [ ] Versioning scheme confirmed (`pubspec.yaml` `version: major.minor.patch+buildNumber` → Android `versionName`/`versionCode`)

## Store listing content
- [ ] App title (max 30 characters)
- [ ] Short description (max 80 characters)
- [ ] Full description (max 4000 characters)
- [ ] App category (e.g. Tools / Productivity / Developer Tools) and tags
- [ ] Contact details: support email (required), phone (optional), website (optional)

## Graphic assets
- [ ] App icon — 512×512 PNG, 32-bit with alpha
- [ ] Feature graphic — 1024×500 PNG/JPG
- [ ] Phone screenshots — min 2, up to 8 (per current Play spec, min dimension ≥320px, max ≤3840px, 16:9 or 9:16)
- [ ] 7" and 10" tablet screenshots (recommended if the app supports tablet layouts)
- [ ] Optional: promo video (YouTube URL)

## Legal & compliance
- [ ] **Privacy Policy** — hosted, publicly reachable URL (required; DataCom stores connection credentials/secrets on-device, so this must clearly state what's stored, that it's encrypted locally via platform keystore, and that nothing is sent to a DataCom-owned server given the local-first decision in [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md))
- [ ] **Data safety form** — declare what data is collected/stored/shared and security practices (encryption at rest, no data leaves device, no account/login)
- [ ] **Content rating questionnaire** (IARC) completed
- [ ] **Target audience & content** — age groups, whether the app appeals to children (affects Families policy requirements)
- [ ] **Ads declaration** — does the app contain ads? (expected: no)
- [ ] **Government apps / COVID-19 tracing / financial features / health declarations** — confirm not applicable
- [ ] **App access** — declare whether all functionality is available without special access, or provide reviewer instructions/test credentials if any gate exists
- [ ] Acknowledge Play Console Developer Program Policies

## Technical / release requirements
- [ ] App targets a Play-compliant API level (Play enforces a minimum target SDK per current policy at time of release — verify against Play Console's current requirement, not this doc, since it changes yearly)
- [ ] Signed **Android App Bundle** (.aab) build produced
- [ ] Enrolled in **Play App Signing**
- [ ] Permissions used by the app justified (e.g. `INTERNET` for connecting to the user's own infrastructure) — Play may require a declaration for sensitive permissions
- [ ] Network security config reviewed if the app connects to private/self-signed infrastructure (see the network-reachability open item in [DESIGN_SUMMARY.md](DESIGN_SUMMARY.md))

## Testing tracks
- [ ] Internal testing track set up (fastest, for the team)
- [ ] Closed testing track (if a wider pre-release group is wanted) — Play requires a minimum closed-testing period with opted-in testers before a new developer account can go to production
- [ ] Production release plan (rollout percentage, countries/pricing)

## Notes
- This checklist can be worked on in parallel with or ahead of the Flutter implementation phases — none of it blocks on app code except the final signed build and screenshots (which need a working app to capture).
- Requirements Google enforces (minimum target SDK, screenshot specs, closed-testing requirements for new accounts) change periodically — re-verify each item against the live Play Console before submitting, don't rely solely on this document.
