# littlevillage-site

Replacement website for littlevillage.org (The Hagedorn Little Village School), moving off WordPress. Static marketing/content site: programs, staff, news, events, contact.

**Status:** Steps 1-8, 9 (News & Events detail pages), and 10 (Parent Association) are complete and live on the Cloudflare Pages preview. Full history of that work - including corrections and decisions made along the way - is archived in `docs/archive/completed-batches.md`. This file covers active/upcoming work only.

**Launch target: mid-September 2026, at an in-person event.** Until then, all work targets the `littlevillage-site.pages.dev` preview only. Custom domain cutover and DNS changes are explicitly out of scope until launch week - do not touch DNS or add the custom domain to the Cloudflare Pages project before then, even if asked to "finish" the deploy pipeline.

**Full plan and rationale:** see the "Little Village Site Rebuild - Jaspr + Sanity" Notion page.

## Tech stack (fixed, don't deviate without asking)

- **Jaspr** - Dart web framework, `mode: static` (SSG). Not an SPA, not SSR, for now.
- **Styling:** Jaspr's native type-safe CSS-in-Dart (`css()`/`@css`/`Styles`). No CSS framework, no preprocessor.
- **Sanity** - CMS, source of truth for all content. Project `f537tj40`, dataset `production`. Same project/dataset as the existing Dart app. Schema lives in the separate `hlvs-studio` repo (`hlvs/schemaTypes/`).
- **Cloudflare Pages** - static host. Preview build at `littlevillage-site.pages.dev` is the only target until launch.
- **Serverpod** - not yet. Future addition once genuinely dynamic/authenticated features are needed (donation flow, parent/staff portal). Contact form backend will NOT use Serverpod - see Step 9c below.

## Guiding principles

- **Dart-first, minimal JS.** Avoid hand-written JS. Exceptions: Sanity client/tooling JS, and Cloudflare Pages Functions (which don't run Dart - see Step 9c).
- **Content boundary:** Sanity owns all editable content. Jaspr owns layout/logic only.
- **Data layer:** never call the Sanity client directly from page components - always go through `ContentRepository` (`lib/sanity/`). This is what lets Serverpod slot in later without a content-layer rewrite.
- **Work in batches, one screen/task at a time.** Finish, verify, and commit one batch before starting the next.
- **Nav is a hardcoded array in `header.dart`.** `SiteSettings.navigation` is queried but intentionally unused - follow the existing pattern, don't switch to Sanity-driven nav without discussing it first.

## Complete: Step 9b - Sanity Rebuild Webhook

Verified working 2026-08-10. Publishing/updating/deleting content in Sanity Studio triggers a Cloudflare Pages rebuild of `littlevillage-site.pages.dev` automatically. Dev preview only - no domain/DNS involved. See `docs/archive/completed-batches.md` for details if needed.

## Complete: Step 9c - Contact Form Backend

Verified working 2026-08-11. The Contact page's "Request Information" and "Schedule a Tour" flows collapsed into one form with a mandatory General Inquiry / Schedule a Tour dropdown (no default selection), honeypot + Cloudflare Turnstile bot protection, and a Cloudflare Pages Function (`functions/api/contact.js`) that sends via Resend from `send.littlevillage.org` to `information@littlevillage.org`. The `ContactForm` `@client` component (`lib/components/contact_form.dart`) handles the real submit flow, including loading/success/error states, required-field indicators (asterisk + screen-reader text, not color-only), and focus/`aria-invalid` handling on the dropdown if the disabled-submit-button UX is ever bypassed. See `docs/archive/completed-batches.md` for details if needed.

## Active: Step 11 - Visual Restyle (Pastel/Fraunces)

Management requested a full-site restyle: current fonts felt "childish," background felt bland. Design produced via Claude Design - handoff folder with 3 reference pages (home/admissions/contact HTML+screenshots) plus a README with the full token system. **This is a skin change only** - no layout, IA, or copy changes. Same components, same structure, same content, just restyled.

**Full token replacement** - old color/font tokens in `theme.dart` are being fully replaced, not kept alongside the new ones. One token set, no dual-system drift.

**Sequencing constraint: Step 11 must be fully complete and verified before Step 9d (custom domain cutover) starts**, even though 9d is already gated to launch week regardless. Don't let the two overlap - the domain shouldn't cut over mid-restyle.

**Global rule for every batch below - style-only:**
No changes to component structure/props, state logic, event handlers, GROQ queries, `ContentRepository`, `functions/api/contact.js`, or ARIA attributes/roles (presence stays identical - only visual treatment changes). No changes to interactive behavior: disabled-button gating on the contact form, the honeypot's visually-hidden-not-display-none technique, Turnstile flow, FAQ expand/collapse, hero carousel autoplay/pause/arrows, mobile nav toggle. If a CSS change touches an element tied to interactive behavior, verify that behavior still works before marking the batch done - a margin or color change silently breaking a hover/focus region is exactly the failure mode to catch here.

**Design tokens (from handoff README):**

- Fonts: Fraunces (serif, headings, weight 500-700, tight letter-spacing -0.015em to -0.02em on H1/H2) + DM Sans (body/UI, weight 400-700). Google Fonts: `family=DM+Sans:wght@400;500;600;700&family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700`
- Colors: navy ink `#17334a` (text), navy-dark `#143c55`/`#102f43` (header bars, footer), blue `#356e8d` (nav links), sky `#eaf5f8`, cream `#fffaf2`, coral `#ef7d68` (the ONLY saturated accent - primary buttons/links/active states), peach `#fff0e8`/`#fde3d5`, green `#4e8b75` (check icons), mint `#e7f3ed`/`#d9ecdf`, yellow `#f5c75f` (step-number circles, small highlights), line/border `#dce7eb`/`#cbdbe2`, muted text `#4e6879`/`#546b78`/`#728591`. Max 2 background tones per page plus the coral accent.
- Shape: card radius 20-28px, pill buttons `border-radius: 999px`, section vertical padding ~56-72px.

- [x] **11.1 - Design tokens foundation** - `theme.dart` fully replaced: new `AppColors` palette (canonical names - navy/navyDark/navyDarker/blue/sky/cream/coral/peach/peachDark/green/mint/mintDark/yellow/line/lineDark/mutedText\*), Fraunces + DM Sans fonts (Google Fonts import updated), new `Radii` and `Spacing` token classes (additive, not yet consumed anywhere). **Legacy token names kept as aliases** (e.g. `AppColors.primary = blue`, `AppColors.accent = coral`) pointing at the new values, so all ~200 existing call sites across 17 files compile and pick up the new colors without any component file being touched this batch - migrate call sites to the canonical names as each page's batch touches that component, then drop the alias. Verified: `dart analyze` clean project-wide, static build succeeds for all 21 routes, and a real headless-browser render confirms both Fraunces and DM Sans actually load and paint (not just fall back), plus the new coral/navy/sky colors rendering on Home and Admissions. **Blast radius flagged for later batches:** two hardcoded (non-token) hex colors exist outside `theme.dart` - `#b3261e` in `lib/components/contact_form.dart` (error-state red) and `#fbfaf8` in `lib/pages/contact.dart` (background) - both belong to 11.5. Separately, `FontFamilies.cursive` is hardcoded as the generic CSS fallback alongside `headingFontFamily` at 81 call sites across 19 files (not just in `theme.dart`, which now correctly uses `FontFamilies.serif`) - cosmetic only (matters solely if Fraunces fails to load), but each page batch should fix its own occurrences when it touches that component.

- [x] **11.2 - Header, utility bar, footer (global chrome)** - `header.dart`, `footer.dart`, `mobile_nav.dart` migrated to the canonical token names (navy/navyDark/navyDarker/blue/coral/yellow/sky/line/mutedTextLight - no more legacy aliases in these three files). Utility bar flipped to a dark navy bar with white text and a coral pill Donate button (was a light bg before, per the reference); logo gets a yellow circular badge treatment via CSS on the existing `<img>` (no new markup); nav links recolored blue with DM Sans (was navy/Fraunces-ish, matching the reference's "playful" font only being reserved for real headings now); Request Info button switched from blue to coral to match its CTA role; footer bg → navy-darker, column titles → yellow uppercase DM Sans labels (were plain white, no transform). Donate-pill focus outline uses white (not blue) against the new dark bg, matching the existing documented rationale already used in the footer. Fixed the `FontFamilies.cursive` generic-fallback mismatch (now `.serif`) in these three files' remaining Fraunces usages, and re-tinted two dropshadow `rgba()` values that were still keyed to the old ink color. **Verified:** `dart analyze` clean, static build succeeds, and a headless-browser pass confirms both interactive behaviors still work post-restyle - the Programs dropdown opens via real `:hover` and via keyboard `:focus-within`, and the mobile hamburger's `aria-expanded` toggle and nav visibility both flip correctly on click.

- [x] **11.3 - Homepage** - `home.dart` fully restyled to the canonical tokens (no legacy aliases left), plus a handful of value-only fixes derived from reading the actual reference markup closely: trust strip changed from one shared-border box to individual left-accent cards (matches reference), age-locator cards get per-card pastel backgrounds via `:nth-child` (peach/sky/mint, no markup change) while **keeping real Sanity photos** rather than adopting the reference's flat placeholder-only card look - the handoff README explicitly says the mockup's placeholders stand in for real photography, so real images are the correct call here, not a deviation. Enrollment teaser lost its bordered/shaded box (reference uses a plain section), donate band went full-bleed yellow with navy-dark text/button (not the coral/peach treatment the legacy `warm*` aliases had implied), news/event rows got a coral Fraunces date badge, current-families icon tiles get distinct peach vs. mint striping via `nth-child` (no modifier class needed). `hero_gallery.dart` radius bumped to 32px and its one `AppColors.ink` reference migrated to `navy`. **Verified:** `dart analyze` clean, static build succeeds, full-page screenshots at desktop and mobile widths match the reference direction, and - since this page carries the highest interactive risk in Step 11 - a scripted headless-browser pass confirmed every hero carousel behavior still works: autoplay advances (~4s interval), hovering pauses it, un-hovering resumes it, both manual arrows work, and `prefers-reduced-motion: reduce` disables autoplay while manual arrows keep working.

- [x] **11.4 - Admissions** - `admissions.dart` and `faq_accordion.dart` fully migrated to canonical tokens. Also restyled the shared `.page-breadcrumb`/`h1`/`h2` rules in `content_page.dart` (used by ~17 pages) since Admissions is the first page batch to touch that shared wrapper - left `.detail-*`/`.link-*` in that same file alone since those belong to News/Events detail (11.8) and the About hub (11.7). Eligibility checklist became one peach card (was a bordered box with a separate colored header bar); enrollment journey converted from a vertical list of photo-rows to a 2x2 grid of cards - kept real Sanity photos rather than the reference's photo-less 4-column layout, same reasoning as 11.3's age cards. $0 callout is now a navy-dark band with a yellow Fraunces value (was a light sky/blue box). Closing CTA flipped from a solid-primary-color box to a light sky section with three pill buttons (was a dark box with white text). The eligibility checkmarks stayed as literal `✓ Label` text (not split into a separate icon element) since the checkmark character is existing page copy, not decoration - same restraint applied to the footer's "↳" arrows in 11.2. **Verified:** `dart analyze` clean, static build succeeds, full-page screenshot matches the reference direction, and a scripted headless-browser pass confirmed the FAQ accordion's actual behavior is untouched - single-open-at-a-time toggling, `aria-expanded` flips correctly per item, and the answer's conditionally-rendered DOM node still tracks open state exactly as the original (unmodified) `_openIndex` state logic dictates.

- [ ] **11.5 - Contact page (handle carefully - newest, most fragile code)** - form, info card, map placeholder. Verify explicitly: mandatory-dropdown disabled-button gating, Turnstile widget renders correctly with new spacing, honeypot still hidden the same way, `aria-invalid`/`aria-describedby` error states, loading/success/error states. Redo a real manual pass through the form, not just a visual glance.

- [ ] **11.6 - Programs hub + 3 detail pages**

- [ ] **11.7 - About family (About/Mission/History/Founders/Staff/Board) + Facilities**

- [ ] **11.8 - News/Events listing + detail pages + newsletter links** - verify filter pills' `aria-pressed` state still functions.

- [ ] **11.9 - Current Families + Parent Association** - verify: embedded calendars unaffected, PA events empty-state still renders correctly, Current Families nav dropdown still works.

- [ ] **11.10 - 404 page + final full-site sweep** - re-check mobile breakpoints (375/768/1024px) against the new tokens, since new spacing/radius values could interact with the existing 7.7/7.8 responsive fixes. Run a real WCAG AA contrast pass on the new palette (muted text tones, coral-on-white links specifically) - 7.6 already established an accessibility bar; this must not regress it.

## Deferred until launch week (mid-September 2026): Step 9d - Custom Domain Cutover

Do not start this step under any circumstances until explicitly told launch is imminent, even if 9b and 9c are both done and verified. Note: this is separate from the Resend subdomain (`send.littlevillage.org`) already set up for 9c - that's isolated and doesn't touch the site's main A/CNAME records.

- [ ] **9d.1 - Production custom domain** - add littlevillage.org as a custom domain on the Cloudflare Pages project.
- [ ] **9d.2 - DNS cutover at GoDaddy** - update DNS to point at Cloudflare.

## Open question

`pages/support_us.dart` exists (added 2026-07-28, linked from the About dropdown) but isn't part of any documented batch, and the header's Donate pill still links to `href="#"`. Needs a decision: does Support Us replace the WordPress -> Give Lively Donate link, or is it separate? Where should the Donate pill point?

## Reference: current WordPress nav (for parity-checking)

Programs and Enrollment (+ Educational Programs, Early Intervention, Preschool, Elementary, Therapeutic Services, Family Services, CPSE Evaluations, Enrollment Info, Summer Rec) - About Us (+ Mission, History, Founders, Admin Staff, Board Members, Upcoming Events, Compliance, Data Privacy & Security, Career Opportunities) - School Facilities - Media (+ Newsletters, In The News, Videos, Pictures) - Contact - Donate (external, Give Lively)
