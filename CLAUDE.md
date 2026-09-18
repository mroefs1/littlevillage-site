# littlevillage-site

Replacement website for littlevillage.org (The Hagedorn Little Village School), moving off WordPress. Static marketing/content site: programs, staff, news, events, contact.

**Status:** Steps 1-31 are complete and pushed to the Cloudflare Pages preview. Only Step 9d (custom domain cutover, deferred to launch week) remains. Full history of that work - every batch, correction, and verification note - is archived in `docs/archive/completed-batches.md`. This file covers active work, standing conventions, and known open items only.

**Launch target: mid-September 2026, at an in-person event.** Until then, all work targets the `littlevillage-site.pages.dev` preview only. Custom domain cutover and DNS changes are explicitly out of scope until launch week - do not touch DNS or add the custom domain to the Cloudflare Pages project before then, even if asked to "finish" the deploy pipeline.

**Full plan and rationale:** see the "Little Village Site Rebuild - Jaspr + Sanity" Notion page.

## Tech stack (fixed, don't deviate without asking)

- **Jaspr** - Dart web framework, `mode: static` (SSG). Not an SPA, not SSR, for now. Internal links are real full-page navigations - the Router is server-rendered and never hydrated as a client-side router.
- **Styling:** Jaspr's native type-safe CSS-in-Dart (`css()`/`@css`/`Styles`). No CSS framework, no preprocessor.
- **Sanity** - CMS, source of truth for all content. Project `f537tj40`, dataset `production`. Same project/dataset as the existing Dart app. Schema lives in the separate `hlvs-studio` repo (`hlvs/schemaTypes/`).
- **Cloudflare Pages** - static host. Preview build at `littlevillage-site.pages.dev` is the only target until launch.
- **Serverpod** - not yet. Future addition once genuinely dynamic/authenticated features are needed (donation flow, parent/staff portal). The contact form backend does NOT use Serverpod - it's a Cloudflare Pages Function (`functions/api/contact.js`) sending via Resend.

## Guiding principles

- **Dart-first, minimal JS.** Avoid hand-written JS. See the exception list below - there are exactly four, all deliberate.
- **Content boundary:** Sanity owns all editable content. Jaspr owns layout/logic only.
- **Data layer:** never call the Sanity client directly from page components - always go through `ContentRepository` (`lib/sanity/`). This is what lets Serverpod slot in later without a content-layer rewrite.
- **Work in batches, one screen/task at a time.** Finish, verify, and commit one batch before starting the next.
- **Nav is a hardcoded array in `header.dart`.** `SiteSettings.navigation` is queried but intentionally unused - follow the existing pattern, don't switch to Sanity-driven nav without discussing it first.

## Standing conventions (carried forward from Steps 1-31)

These were established and paid for across the completed batches. Follow them; changing one is a discussion, not a judgement call.

**Where the content boundary actually falls.** Sanity owns editable prose, images, links, and lists an editor would reasonably want to change. Dart owns presentation decisions that happen to be data-shaped: per-card pastel background colors (assigned by render position through a 7-token cycle - peach, sky, mint, peachDark, mintDark, offWhite, cream), anchor ids for deep links (`lib/constants/therapeutic_sections.dart`), the nav array, and fixed structural tag lists like the services pills and the language list. Repeated precedent - don't add an editor-facing field for something the Dart side has to name anyway.

**The diagonal hatch means "photo pending" and nothing else.** `repeating-linear-gradient` is `PhotoPlaceholder`'s device, so it must appear only where a real photo is genuinely waiting on an upload. The homepage Current Families band and the Current Families feature cards used it decoratively behind finished icons, and it read as unfinished work for exactly that reason - both are flat peach/mint tints now. Icon tiles get a flat token tint; don't reintroduce a hatch as decoration.

**Icons are inlined SVG from `AppIcons`, never emoji.** Emoji are a font: they render differently on every OS, size themselves off `font-size`, and wash out against a tint. `icons.dart` says this and the homepage followed it, but `current_families.dart` kept `🤝`/`📄` until Step 32. Two traps when adding one: an SVG has **no intrinsic size**, so every new slot needs explicit `width`/`height` (an unsized icon collapses or explodes silently), and it needs `flex: 0 0` anywhere it sits beside text that can grow.

**Pass-through, not opt-in.** New Sanity-backed features render nothing at all when the field is absent - no wrapper, no gap, no placeholder - so content can be added later with no deploy. Established by `donateUrl`, the `video` type, `socialLinks`, and `page` images.

**Hand-written JS - four sanctioned exceptions, don't add a fifth without asking.** Sanity client/tooling JS; `functions/api/contact.js` (Pages Functions don't run Dart); `AccessibilityBoot`'s inline head script; `SplashBoot`'s inline head script. The last two must be blocking inline scripts because `@client` islands hydrate after first paint, so applying at hydration would cause a visible flash for exactly the people who chose the setting. Everything else, including the whole Google Translate integration, is Dart via `js_interop`.

**Schema changes go in `hlvs-studio` and get pushed.** Validate with `sanity schema validate`, commit, and push to `origin/main` - never leave a schema change local-only (the `parentAssociation` drift lesson from Step 10). New types and fields also need a `sanity deploy` before editors can see them in the hosted Studio; **there are two hosted studios, so deploying is Mike's call - don't do it unasked.**

**Sanity rebuild webhook: do not reintroduce a type allowlist.** The filter is `!(_type match "sanity.*") && !(_id in path("drafts.**"))`. An allowlist means every new type must be remembered in a dashboard nobody looks at, and forgetting it fails silently - publishing works, the site just stops rebuilding.

**`Breakpoints.nav` must be re-probed whenever nav items are added or removed.** It exists because the desktop nav row stops fitting, and it's been re-measured twice already (1260 -> 1140). It's deliberately the only breakpoint in `em`, because it's a text-fitting threshold, not a layout one. To re-probe: set it very low temporarily, build, and sweep viewport widths for the first sign of horizontal overflow.

**`styles()` argument order is lint-enforced, and the order is the `Styles` constructor's own parameter list** - roughly: display, position, size (`maxWidth` before `padding`), padding, margin, border, radius, overflow, flex/grid, gap, then `color`, `textAlign`, `fontSize`, `fontWeight`, `textDecoration`, backgrounds, `raw` last. `dart fix` will not sort it for you.

**Accessibility posture: WCAG 2.1 AA, and no overlay widgets, ever.** Overlays were evaluated and rejected on evidence (the FTC's $1M accessiBe fine, lawsuits targeting overlay-equipped sites, the Overlay Fact Sheet, and the basic fact that screen readers read the DOM). The legacy site never ran one either - don't "restore" it. Keep new interactive work at the bar the site already meets: 24px minimum target size, no color-only distinctions, real keyboard operability, and `translate="no"` on the school's name.

## Verification discipline (each of these caught a real bug)

The recurring failure mode on this project is work that looks correct and silently isn't. In order of how often it has bitten:

1. **Read the emitted CSS, not just the Dart.** Caught four separate bugs. Two specific traps: `css()` inside a nested block prefixes **only the first selector in a comma-separated list**, so `css('.a, .b')` scopes `.a` and lets `.b` escape entirely; and interpolation written as `\${scope}` in a parameterised selector emits the literal text and matches nothing. Specificity is the other one - a mobile override written at two classes loses to a base rule at three, media query regardless.
2. **Computed-style checks cannot catch styling that isn't taking effect.** The language switcher's contrast math passed while the control rendered as a plain white native `<select>`, because browsers ignore `color`/`background` on a select without `appearance: none`. **Look at a screenshot**, don't just measure.
3. **`document.scrollWidth` is `undefined`** - it belongs to `documentElement`, so assertions written against it pass vacuously. And even correctly written, it cannot detect the utility bar overflowing: that row is right-justified, so overflow runs off the **left** edge. Compare the leftmost child's `x` against the bar's own content-left instead.
4. **Open image files before writing alt text.** Four bad drafts caught this way - two in Step 21, plus three filename-as-alt values in Step 28, one of which described the wrong subject entirely.
5. **`waitUntil: 'networkidle'` never settles on a page with a live embed.** The Contact page's Google Map keeps polling, so a check written that way times out rather than failing. Use `load`.
6. **A verification method can be broken in the same silent way as the code.** Step 29 shipped `document.scrollWidth` assertions that were reading `undefined`; Step 30's first hero-contrast measurement reported FAIL because it sampled anti-aliased glyph edges as though they were background. Sanity-check that a check can actually fail before believing it passes. And a screenshot read by eye is not a measurement - Step 30 nearly "fixed" card heights that measured identical.
7. **Verify behaviour with real interaction, scoped correctly.** An unscoped `document.querySelector('.nav-dropdown-menu')` grabs the first of four dropdowns and falsely reports the one you're testing as broken.

## Known area of concern: Dart SDK pinning in `build.sh`

`build.sh` fetches the Dart SDK itself (Cloudflare's build image doesn't ship Dart) and used to always grab `channels/stable/release/latest`. **On 2026-08-12, Dart 3.13.0 broke the Cloudflare build** - `jaspr build` crashed and then hung (not a clean failure) partway through static route generation, on `/history`, with a `NoSuchMethodError: The method '&' was called on null` several layers deep inside `dart:_compact_hash`, inside Jaspr's async SSR rebuild machinery (`AsyncBuildOwner`/`TaskChain`) - not application code. The exact same commit built cleanly, repeatedly, all session on a local machine running Dart 3.12.1. Fix: `build.sh` now pins `DART_SDK_VERSION="3.12.1"` explicitly instead of `latest`. **If a future Cloudflare build fails or hangs with no code-level explanation, check this first** - it may mean Dart shipped a new stable release that regressed something Jaspr depends on, same failure mode as this incident. Bump the pin deliberately (test locally on the new version first) rather than silently reverting to `latest`.

## Open items (flagged during completed work, deliberately not fixed)

None of these are blockers; each was raised and left as a decision or a small follow-up. Sourced from the batches archived in `docs/archive/completed-batches.md`.

**Needs a decision from Mike:**
- **Google's business listing for the school reads "The Hagedorn Village School"**, missing "Little" - visible on the Contact page map pin and in Google search. Fixed through Google Business Profile, not in this repo.
- **"Tuition-free" still appears in three places** after Step 27 softened the cost claim elsewhere: `constants/seo.dart`'s `defaultMetaDescription` (the fallback on every page that doesn't set its own), the Programs hub SEO description, and the Support Us intro. Same claim in the old framing.
- **Movement Therapy and Nursing Services have no inbound pill** from any program page. Adding one changes page content, so it needs a call.
- **A typo in the Golden Rule event's Sanity `description`:** `jennifer.kirnicic@littlevillage.org` vs the graphic's `Jennifer.kirincic@`. Rendered on `/events/2027-golden-rule-award-dinner`. One-line fix once confirmed which is right.

**From the Step 30 homepage redesign:**
- ~~**The three Services & Support cards have no photos**~~ - resolved 2026-09-17 by pointing each card's `image` at the asset its own page already used. Two corrections worth keeping: the field is on the `homepage` singleton's `serviceCards[]` array, **not** on the `page` documents (the original note had this wrong, and it is the reason the two rows behave differently - Educational Programs cards read the `program` document's image automatically, while a service card's photo is a separate per-card upload that defaults to a placeholder). Because the asset is referenced by the card, swapping a page's hero no longer updates the homepage - the two can now drift.
- **`/related-services` carries placeholder copy I wrote**, pending that department's documentation. It reads as provisional on purpose, but it is not sourced content - replace it before launch.
- **"Careers & staff portal"** in the Current Families band now links to `/careers`, but no staff portal exists. The label is the mockup's own; worth deciding whether to drop the second half. The footer's "Parent portal" link is the same question.
- **The Upcoming Events column shows one card** against the news column's three, because one event exists. It handles it correctly but reads sparse - two more events would balance the band.

**Small, uncontroversial follow-ups:**
- `about.dart`'s sub-nav row still has no **Careers** entry (missed in Step 20) though the About dropdown does. One line.
- The footer's "Get started" column still says **"Request info"** while the nav pill now says "Contact" - both link to `/contact`. Left alone because the nav simplification was scoped to the nav bar.
- **The Compliance page likely has the same full-width body text** that Data Privacy was fixed for, since both sit on the same container. Never flagged, never looked at.
- **Three `page` heroes have placeholder alt text** - `therapeutic-services` reads `"therapeutic"`, `related-services` reads `"rs"`, `cpse-evaluations` reads `"eval"`. Live on those pages now, and exactly the filename-as-alt failure Step 28 caught. Real alt text for all three images was written on 2026-09-17 when the homepage cards were filled (same three photos) - copy it off the `homepage` singleton's `serviceCards[].image.alt`. Content-only, no deploy. Worth a sweep for others: nothing checks this at build time.
- **Three placeholder boxes still render** pending photos: 1 each on About, Contact and Support Us. All have a document and field waiting - each is one upload, no deploy. (Admissions' four journey photos were uploaded at some point and this line was stale; they render for real as of Step 33.)
- **Admissions' four journey photos have placeholder alt text** - `"admissions 1"`, `"adm 2"`, `"adm 3"`, `"adm 4"`. Same failure as the three `page` heroes above, and more visible now that the photos render at 16:9 instead of a 90px sliver. Needs someone to look at each image and write real alt text; content-only, no deploy.
- **The Facilities hero is a 1024px original** rendering at 1088px, so it's slightly upscaled and soft. Only a larger re-upload fixes it.
- **No blockquote CSS exists anywhere in the codebase.** `PortableTextView` renders the element, so a page that genuinely needs a pull quote would fall back to the browser default indent. That rule still needs writing.

**Known limitations, accepted:**
- **Turnstile overflows at a 320px viewport.** Cloudflare renders it at a fixed 300px minimum and there are 280px after page padding, so no amount of padding tuning fits it. Improved from 386px to 350px of overflow in Step 24; the real fix is Turnstile's compact mode, which means touching the submit flow.
- **RTL is partial.** For Arabic and Urdu, Google Translate sets `lang` and `translated-rtl` but not `dir="rtl"`, so text right-aligns per block while layout stays LTR. Reads fine, no overflow, and it's not a regression against WordPress - true RTL would be a separate, much larger piece of work.
- **The Google Translate widget has been unmaintained since ~2018.** Accepted deliberately; everything Google-specific is confined to `language_switcher.dart`, so the day it breaks is a one-file fix.
- **Staff/Board `CollectionCard` styling was never seen against real content** (Step 11.7) - the dev dataset only had the empty state. Worth a spot-check once real staff/board content exists.
- **The splash screen has not been through a machine-translated pass.** Safe by construction (Translate rewrites text nodes, not attributes), but untested.

**Before launch, for a human:** programmatic accessibility checks are a proxy, not a screen-reader test. Someone should spend twenty minutes on the site with VoiceOver or NVDA - and if any family or staff member uses a screen reader daily, their feedback is worth more than every automated sweep run so far.

## Deferred until launch week (mid-September 2026): Step 9d - Custom Domain Cutover

Do not start this step under any circumstances until explicitly told launch is imminent. Note: this is separate from the Resend subdomain (`send.littlevillage.org`) already set up for the contact form - that's isolated and doesn't touch the site's main A/CNAME records.

- [ ] **9d.1 - Production custom domain** - add littlevillage.org as a custom domain on the Cloudflare Pages project.
- [ ] **9d.2 - DNS cutover at GoDaddy** - update DNS to point at Cloudflare.

**Two things will reset at cutover, both harmless and both expected** - worth knowing before anyone reports them as bugs. The `googtrans` cookie is domain-scoped and the splash screen's `localStorage` dismissal is origin-scoped, so a language choice and a dismissed splash won't carry over from `pages.dev`. Visitors simply choose once more.

## Reference: current WordPress nav (for parity-checking)

Programs and Enrollment (+ Educational Programs, Early Intervention, Preschool, Elementary, Therapeutic Services, Family Services, CPSE Evaluations, Enrollment Info, Summer Rec) - About Us (+ Mission, History, Founders, Admin Staff, Board Members, Upcoming Events, Compliance, Data Privacy & Security, Career Opportunities) - School Facilities - Media (+ Newsletters, In The News, Videos, Pictures) - Contact - Donate (external, Give Lively)
