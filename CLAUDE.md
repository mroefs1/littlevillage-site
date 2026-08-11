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

## Active: Step 9c - Contact Form Backend

**Design decision (finalized 2026-08-10, per discussion with admissions):** the separate "Request Information" and "Schedule a Tour" flows on the Contact page collapse into **one form** with a **mandatory** dropdown at the top: "General Inquiry" / "Schedule a Tour". No default selection - starts on a disabled placeholder option ("Select one..."). The dropdown only tags intent for routing/subject-line purposes; **both request types use the exact same fields** (name, child's DOB, county/district, phone, email, message). Admissions explicitly does NOT want a preferred-date/time field for tour requests - they'll handle scheduling back-and-forth themselves by email/phone after receiving the request.

**Bot protection (both required, not optional):**

- Honeypot field - a hidden field real users never fill in. If populated, silently return success without sending anything.
- **Cloudflare Turnstile** - free, privacy-friendlier than reCAPTCHA. Public site key ships in the `@client` component. Secret key (`TURNSTILE_SECRET_KEY`, already added as a Cloudflare Pages secret) is verified server-side via the siteverify API before any submission is trusted. Consider the Cloudflare Pages Functions Turnstile plugin to simplify the server-side check rather than hand-rolling the fetch to siteverify - check current docs for the plugin's exact API before using it.

**Resend (verified, ready to use):** sending domain `send.littlevillage.org` is verified in Resend. `RESEND_API_KEY` is already added as a Cloudflare Pages secret. **From address must use the verified subdomain** (e.g. `contact@send.littlevillage.org`) - Resend cannot send as an unverified address. Set `reply-to` to the submitter's email so replies go straight to the parent. **Destination inbox: `information@littlevillage.org`** (confirmed).

- [x] **9c.1 - Function scaffold + validation (honeypot + Turnstile)** - `functions/api/contact.js` live. Validates `requestType` (exactly `"general"`/`"tour"`, 400 otherwise), name/message/phone-or-email, honeypot (silent `{success:true}`), and Turnstile via siteverify. Verified 2026-08-11 via curl against the preview across all listed cases (missing/invalid requestType, missing required fields, honeypot filled, missing/bad Turnstile token, malformed JSON) - correct status codes and JSON shapes confirmed.

- [x] **9c.2 - Resend integration** - sends via Resend's raw REST API (no SDK/npm dependency, since the build pipeline is Dart-only with no node_modules step). From `send.littlevillage.org`, to `information@littlevillage.org`, subject/body branch on `requestType`, `reply_to` set to submitter's email. Resend failures return a distinct 502. Verified 2026-08-11 with a real end-to-end submission (real Turnstile token solved in a live browser, not automation - Turnstile blocks headless/scripted solves by design) - email confirmed arrived with correct reply-to.

- [x] **9c.3 - Wire the Contact page to the function, single form** - new `ContactForm` `@client` component (`lib/components/contact_form.dart`) replaces the static form markup: submit button `disabled` bound to `requestType == null`, honeypot field added (visually hidden off-screen, not `display:none`, to avoid trivial bot detection), fetch-based submit to `/api/contact` with client-side validation mirroring the server's required fields. Turnstile widget script/container now live inside this component. Fields are uncontrolled (read via `GlobalNodeKey` at submit time) rather than tracked in `State`, to avoid textarea cursor-jump bugs from per-keystroke re-renders - `requestType` is the one exception since it drives the disabled-button state. Verified 2026-08-11 with a real submission through the actual page UI - dropdown correctly gates the button, email arrived. Copy note (2026-08-11, per Mike): removed "one business day" language from the Contact page subtitle/SEO description and the success message - now just "Thanks - we'll be in touch soon."

- [ ] **9c.4 - States & accessibility polish** - loading state (disable submit, spinner/pending indicator), success state (confirmation message, clear the form), error state (accessible inline error via an aria-live region, matching the 7.6 accessibility conventions - preserve what the user typed rather than clearing it on error). Specifically handle the case where the disabled-button UX gets bypassed (JS disabled, race condition, or a bug) - the 400 response from 9c.1's `requestType` validation needs a clear, accessible error message that points at the dropdown specifically, not a generic "something went wrong." **Added 2026-08-11, per Mike:** mark required fields with an asterisk or other visible (not color-only) indicator so it's obvious which fields are mandatory before submitting. Verify with a manual pass through all three states, plus a screen-reader spot-check of the error announcement.

## Deferred until launch week (mid-September 2026): Step 9d - Custom Domain Cutover

Do not start this step under any circumstances until explicitly told launch is imminent, even if 9b and 9c are both done and verified. Note: this is separate from the Resend subdomain (`send.littlevillage.org`) already set up for 9c - that's isolated and doesn't touch the site's main A/CNAME records.

- [ ] **9d.1 - Production custom domain** - add littlevillage.org as a custom domain on the Cloudflare Pages project.
- [ ] **9d.2 - DNS cutover at GoDaddy** - update DNS to point at Cloudflare.

## Open question

`pages/support_us.dart` exists (added 2026-07-28, linked from the About dropdown) but isn't part of any documented batch, and the header's Donate pill still links to `href="#"`. Needs a decision: does Support Us replace the WordPress -> Give Lively Donate link, or is it separate? Where should the Donate pill point?

## Reference: current WordPress nav (for parity-checking)

Programs and Enrollment (+ Educational Programs, Early Intervention, Preschool, Elementary, Therapeutic Services, Family Services, CPSE Evaluations, Enrollment Info, Summer Rec) - About Us (+ Mission, History, Founders, Admin Staff, Board Members, Upcoming Events, Compliance, Data Privacy & Security, Career Opportunities) - School Facilities - Media (+ Newsletters, In The News, Videos, Pictures) - Contact - Donate (external, Give Lively)
