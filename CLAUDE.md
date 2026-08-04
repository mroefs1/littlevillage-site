# littlevillage-site

Replacement website for littlevillage.org (The Hagedorn Little Village School), moving off WordPress. Static marketing/content site for a school/nonprofit: programs, staff, news, events, contact.

**Status: starting from zero.** No code exists yet — this file is the brief for initial scaffolding and ongoing work.

## Tech stack (fixed, don't deviate without asking)

- **Jaspr** — Dart web framework, `mode: static` (SSG). Not an SPA, not SSR, for now.
- **Styling: Jaspr's native type-safe CSS-in-Dart** (`css()`/`@css`/`Styles`) — see "Styling" section below for why this replaced the original Sass plan. No CSS framework (no Tailwind/Bulma/etc).
- **Sanity** — CMS, source of truth for all content. Same Sanity **project and dataset** as our existing Dart app — reuse the client/query/model code from that app rather than reimplementing it if it's available as a shared package or can be copied over.
- **Serverpod** — not yet, future addition once we need dynamic/authenticated features (donation flow, contact form backend, staff/parent portal). Don't scaffold this now; just keep the architecture from accidentally blocking it later (see "Data layer" below).

## Guiding constraint: Dart-first, minimal JS

Same philosophy as the existing app: as much as possible should be Dart, compiled by Jaspr. Avoid hand-written JS. The **only** expected exception is whatever JS is inherent to the Sanity client/tooling — that's known and fine. If a task seems to need custom JS, stop and ask rather than reaching for it by default; there's probably a Dart/Jaspr-native way to do it.

## Rendering mode

Static generation. Content is public and changes infrequently (news, programs, staff bios, about pages). `jaspr build` produces static HTML — deployable to any static host (Netlify/Vercel/Cloudflare Pages/GitHub Pages, TBD). Content freshness after a Sanity publish is handled by a **rebuild webhook**, not by SSR — don't introduce SSR to solve "the content is stale" problems.

SSR is reserved for genuinely dynamic pages later (once Serverpod exists). Keep that door open but don't build for it prematurely.

## Content boundary

Sanity owns all editable content (portable text, images, structured fields). Jaspr owns layout, components, and routing only. Don't hardcode copy that should live in Sanity.

### Content types to model in Sanity (mirrors current WordPress structure)

- `siteSettings` (singleton) — nav structure, footer links, social links, phone/email
- `page` (flexible) — About/Mission/History/Facilities-type pages: title, slug, portable text body, hero image
- `newsPost` — title, slug, excerpt, body, featured image, publish date
- `event` — title, date, description, image, RSVP/ticket link
- `program` — title, slug, description, age range, related programs (Programs & Enrollment section)
- `staffMember` / `boardMember` — name, title, bio, photo

Check the existing app first for a portable-text → Dart-component renderer to adapt, and for existing GROQ queries/typed models — reuse over reimplementing.

## Data layer — keep this abstracted

Don't call the Sanity client directly from page components. Put a `ContentRepository`-style interface between pages and Sanity queries (e.g. under `lib/sanity/`). This is what lets Serverpod slot in later — as an additional service behind the same kind of interface — without a rewrite of the content layer, and lets individual pages move from SSG to SSR selectively down the line.

## Suggested project structure

```
littlevillage_site/
  lib/
    main.dart              # entry, router setup
    app.dart
    pages/                 # one component per route: home, about, programs, contact...
    components/            # nav, footer, hero, news_card, staff_card, etc.
    sanity/
      client.dart          # thin wrapper around existing Sanity client (or shared package)
      queries.dart         # GROQ queries per content type
      models/              # typed models: NewsPost, StaffMember, Program, Event...
    styles/                # shared Dart CSS-in-Dart definitions (colors, typography, breakpoints) used via @css across components
  web/
  build.yaml
```

Key deps as of this writing: `jaspr ^0.22.0`, `jaspr_content ^0.4.5`, `jaspr_router ^0.8.0`; dev deps `jaspr_builder ^0.22.0`, `jaspr_lints ^0.6.0`. Verify current versions against `pub.dev` when scaffolding, since these move.

## Styling

**Correction (was wrong earlier):** this doc previously said Sass was compiled via built-in `jaspr_builder` support — that's not accurate, Jaspr has no built-in `.scss` pipeline. Confirmed by checking Jaspr docs directly.

**Current approach: Jaspr's native type-safe CSS-in-Dart** (`css()` / `@css`, exported via the `Styles` class from `package:jaspr/jaspr.dart`). Define styles alongside components for locality (`@css List<StyleRule> get styles => [...]`), using nested selectors (`&`, `&:hover`, etc.) and typed properties (`.px`, `Colors.black`, etc.). Supports `css.media()` for responsive breakpoints and `css.import()`/`css.fontFace()` for external stylesheets/fonts if needed. This is consistent with the Dart-first / minimal-JS constraint — no preprocessor, no separate build step.

Sass remains an option in principle (Jaspr can integrate arbitrary CSS approaches, including external `.scss` pre-compiled outside Jaspr's pipeline), but it's not the default — don't add a Sass toolchain without discussing it first.

### Design source: Claude Design templates

There are templates produced in Claude Design that should guide the front-end styling — treat them as the visual reference (layout, spacing, typography, color) to translate into Jaspr's CSS-in-Dart, not as literal code to paste in. Ask for the relevant template(s) before styling a given page/view if they haven't been provided yet.

### Work in batches, one screen/page at a time

Style one page/view per batch, the same way we worked through the app restyling. Don't sweep across multiple pages or components in a single pass. Finish and check in on one page's styling before moving to the next, so feedback on one page can inform the rest rather than having to unwind changes across many files at once.

## Build order

1. **Scaffold** — `jaspr create`, confirm a static "hello world" builds and runs end-to-end before writing real pages.
2. **Layout shell** — nav, footer, base page template, shared CSS-in-Dart variables/typography, placeholder content matching current site structure.
3. **Sanity wiring** — connect the (reused) client, write GROQ queries for one content type first (`siteSettings` or `page`), confirm data flows into a component at build time.
4. **Static pages** — About, Mission, History, Facilities, Contact.
5. **Collections** — News/events listing + detail pages, staff/board listing (exercises `jaspr_router`).
6. **Programs & Enrollment section** — nested nav, more structured content.
7. **Polish** — 404 page, meta tags/SEO, sitemap generation, accessibility pass, mobile responsiveness.
8. **Deploy pipeline** — static host + Sanity webhook to trigger rebuilds on publish.

Work through these roughly in order; check in before jumping ahead to later steps.

## Current design handoff batches (`design_handoff_homepage_admissions 2/`)

Nav/footer/theme tokens (`components/header.dart`, `components/footer.dart`, `constants/theme.dart`) are already built from this handoff. Remaining work, one batch per page per the rule above:

1. **Homepage** (`pages/home.dart`) — fully specified, no schema gaps. Hero, trust strip, age-locator cards, enrollment teaser, latest news/events (2 each, existing `contentRepository`), Current Families band, donate band.
2. **Admissions** (`pages/admissions.dart`) — fully specified. Eligibility checklist, 4-step journey, $0 callout, FAQ accordion (needs a small `@client` component for expand/collapse), big CTA band.
3. **Programs hub + 3 detail pages** — new routes, data-driven like news/events (loop `getPrograms()`, one route per slug). Age-bands map via the existing `category` enum (Early Intervention/Preschool/Elementary) — no schema change needed. Photos are dashed-placeholder blocks until real photography exists.
4. **About redesign** (`pages/about.dart`) — replaces the current link-hub with inline stats/mission/team/accreditation content per the handoff. Open decision before starting: how to keep Mission/History/Founders/Staff/Board reachable, since the new design drops the link grid.
5. **Contact redesign** (`pages/contact.dart`) — two-column form + info card. Info card can pull phone/email from `SiteSettings` (modeled, currently unused). Form stays static/non-functional until a backend is decided.
6. **News & Events additions** (`pages/news_events.dart`) — filter pills (can be a real client-side toggle) + newsletter download links (from sanity) are to be present.
7. **Current Families** (new page/route) — needs a `Document` model/query wired to the existing `doc` Sanity type (unused so far), plus a real gap: no lightweight "calendar closure/key date" content type yet (`event` requires two images, wrong shape for simple closures). Add "Current Families" link to primary nav bar. Suggest embedding google calendar instead of pulling that information from Sanity. The app uses that approach.

Handoff README mentions Serverpod — that's stale/wrong, CLAUDE.md above is authoritative: no Serverpod yet, everything data-backed goes through Sanity with the exception of google calendar.

## Reference: current WordPress nav (for parity-checking)

- Programs and Enrollment (+ Educational Programs, Early Intervention, Preschool, Elementary, Therapeutic Services, Family Services, CPSE Evaluations, Enrollment Info, Summer Rec)
- About Us (+ Mission, History, Founders, Admin Staff, Board Members, Upcoming Events, Compliance, Data Privacy & Security, Career Opportunities)
- School Facilities
- Media (+ Newsletters, In The News, Videos, Pictures)
- Contact
- Donate (external link to Give Lively)
- Homepage also features: Latest News feed, Events feed, Parent Info/Documents/Careers quick links, Employee Portal, Outlook Web Access

Full plan and rationale: see the "Little Village Site Rebuild — Jaspr + Sanity" Notion page.

## Step 7: Polish — Batches

Work through these in order. Complete, verify, and check in each batch
before starting the next. Do not start a batch until the prior one is
committed.

### Batch 7.1 — 404 Page

- Build a custom 404/not-found route styled consistently with site chrome
  (header/footer/theme tokens already in `constants/theme.dart`)
- Include a link back to the homepage and (optionally) to the primary nav sections
- Verify: hitting an unknown route locally renders this page, not a framework default

### Batch 7.2 — SEO Meta Helper + Static/About Pages

- Build a small reusable meta-tag component/helper (title, description,
  canonical URL, Open Graph tags, favicon/touch-icon references)
- Apply it to: Home, About (+ Mission/History/Founders/Staff/Board sub-nav
  pages), Contact, Current Families
- Pull title/description from Sanity page content where available; sensible
  fallback defaults otherwise
- Verify: view-source on each page shows correct <title> and OG tags

### Batch 7.3 — SEO Meta — Collections & Programs

- Apply the meta helper from 7.2 to: Programs hub + 3 program detail pages,
  News/Events listing + detail pages, Staff/Board listing
- Dynamic pages (news post, event, program detail) should generate
  per-item title/description from the Sanity document, not a static default
- Verify: spot-check a few detail-page URLs for correct per-item meta

### Batch 7.4 — Sitemap + robots.txt

- Build-time sitemap.xml generator covering all static routes and all
  dynamic routes (news posts, events, program pages) sourced from Sanity
- Add robots.txt referencing the sitemap
- Verify: sitemap.xml lists every real route with no 404s, robots.txt is valid

### Batch 7.5 — Accessibility: Layout & Navigation

- Skip-to-content link, landmark roles (header/nav/main/footer)
- Keyboard focus states and tab order across header nav, footer, mobile menu toggle
- Color contrast check against `constants/theme.dart` tokens; fix any
  failing text/background combos
- Verify: full keyboard-only pass through nav + footer; automated a11y
  check (e.g. axe) on layout shell

### Batch 7.6 — Accessibility: Page Content & Interactive Components

- Alt text for all images (hero images, staff/board photos, program images)
- Correct heading hierarchy (single h1 per page, no skipped levels)
- Form labels on the Contact form
- ARIA states for the two `@client` interactive components: FAQ accordion
  (Admissions) and news/events filter pills
- Verify: automated a11y check on each page template, manual screen-reader
  spot-check of the accordion and filter pills

### Batch 7.7 — Mobile Responsiveness: Core Pages

- Homepage, Admissions, About, Contact, Current Families at mobile/tablet
  breakpoints (using `css.media()` per the existing styling approach)
- Verify: manual check at 375px/768px/1024px, no overflow or overlap

### Batch 7.8 — Mobile Responsiveness: Collections & Programs

- Programs hub + 3 detail pages, News/Events listing + detail, Staff/Board
  listing at the same breakpoints as 7.7
- Verify: same breakpoint check; confirm filter pills and cards reflow
  correctly on small screens

## Home Hero Redesign — Batch 8

Work through these in order. Complete, verify, and check in each batch
before starting the next. Do not start a batch until the prior one is
committed.

### Batch 8.1 — Two-column hero shell (desktop)

- In the hero component, change the container to a two-column layout
  (CSS grid or flex, 50/50 split) at desktop breakpoints
- Move the existing text block ("a place where your child is understood...",
  subhead, CTA) into the left column — content and styling unchanged
- Remove the current hero image placeholder markup; swap in an empty
  right-column slot sized to fill the remaining 50%
- Scope to desktop only — mobile is handled in Batch 5
- Verify: at desktop widths the text sits flush in the left half, the right
  half is an empty block of matching height, no change to the text's own
  styling/spacing

### Batch 8.2 — Sanity: hero gallery field + query + model

- Add a `heroGallery` field to `siteSettings` — array of images, each with
  a required alt text field (this is a site-wide singleton, same home as
  nav/footer/social links)
- Extend the existing `SiteSettings` GROQ query and typed model to include
  `heroGallery`
- Wire it through the existing `ContentRepository` interface — no new
  abstraction needed, this follows the same path every other content type
  already uses
- Verify: querying `SiteSettings` returns the (possibly empty) gallery
  array with image URL + alt text per item

### Batch 8.3 — Gallery component: image strip from Sanity data

- New component: `components/hero_gallery.dart` — takes the `heroGallery`
  list from `ContentRepository`, renders it as a horizontal row inside a
  container (`overflow-x: hidden` for now; motion comes in Batch 4)
- Wire it into the right-column slot from Batch 1
- Handle an empty or not-yet-populated gallery gracefully — no broken
  layout — since the Sanity field will start empty until photos are added
- Verify: with test images added in Sanity Studio, the gallery renders
  them in a row at the correct aspect ratio/height, filling the right
  column; with the field empty, the layout doesn't break

### Batch 8.4 — Motion: auto-scroll, hover-pause, manual arrows

- Auto-scroll the strip continuously; loop seamlessly at the end (e.g.
  duplicate the image list once so the wrap isn't visible)
- Pause auto-scroll on mouse hover over the gallery, resume on mouse-leave
- Add prev/next arrow buttons overlaid on the gallery; clicking
  advances/retreats one photo-width and briefly pauses auto-scroll so it
  doesn't fight the click
- Implement the scroll/timer logic as a Jaspr client/island component
  rather than hand-written JS, consistent with the Dart-first/minimal-JS
  constraint — confirm the current client-component annotation/syntax
  against installed Jaspr version's docs before writing it
- Respect `prefers-reduced-motion`: if set, don't auto-scroll — static
  strip, arrows still work
- Arrow buttons need `aria-label`s ("Previous photo" / "Next photo")
  since they carry no visible text
- Verify: gallery auto-scrolls and loops smoothly, stops on hover and
  resumes on mouse-leave, arrows manually advance/retreat, reduced-motion
  disables autoplay, keyboard focus reaches both arrows

### Batch 8.5 — Mobile: text-only hero

- At mobile breakpoints (use the existing tokens in `constants/theme.dart`,
  don't invent new ones), hide the gallery entirely and let the text
  column take full width
- Confirm no layout shift or dead space is left where the gallery would
  have been
- Verify: at mobile widths only the text hero shows, full-width, no
  orphaned gallery container; gallery reappears correctly above the
  tablet/desktop breakpoint

## Feature Batch 9: News & Events Tiles + Event Detail Pages

### Problem Statement

- Home page news/events tiles are too narrow vertically — need to be taller.
- Home page tiles currently either redirect to the legacy WordPress site or link nowhere. They need to route to the actual in-app news/event item.
- `/news` page tile grid looks correct, but there's no dedicated detail page for an individual news or event item to link to yet.
- The mobile app already solves this problem: it fetches a single news/event document from Sanity and renders a native detail screen. This batch mirrors that data-fetching and rendering approach in Jaspr rather than inventing a new one.

### Confirmed Decisions

- **News** and **Events** are separate Sanity document types with different fields (not a shared type with a variant flag).
- **PA Events** are a third, related Sanity document type — out of scope for this batch, to be handled separately later. Don't fold PA Events into the News/Events routing or queries here.
- No need to preserve legacy WordPress URLs — this is a clean break, no redirect mapping required.
- Portable Text rendering already exists in the codebase — reuse it, don't rebuild it.

### Guiding Principles for This Batch

- Work in checkpoints, same as the page-by-page styling process: finish and verify one batch below before starting the next.
- Sanity is the source of truth. Confirm exact field names for News and Events before writing queries — don't guess.
- All new Sanity reads go through `ContentRepository`. No direct Sanity client calls from widgets or pages.
- Treat the mobile app's existing query + detail screen as the reference implementation for field names, slug handling, and Portable Text usage.

---

### Batch 9.1 — Sanity Field Audit (no code changes)

**Goal:** Nail down the exact field names for the two document types before writing anything.

- Pull the **News** document type schema from Sanity Studio: slug field name, title, body (Portable Text), author/category, hero image, etc.
- Pull the **Events** document type schema separately: slug field name, title, body, date/start-end time, location, hero image, etc.
- Confirm slug fields don't collide in a way that matters (News and Events will each have their own route namespace, so uniqueness only needs to hold within each type).
- If available, pull the mobile app's existing GROQ queries for a single News item and a single Event item — reuse them instead of writing new ones from scratch.
- Explicitly note that PA Events is a separate type and is not part of this audit.

**Definition of done:** A short written note (in this file, or a scratch doc linked from it) listing both types' field names and slug pattern. Nothing merged yet.

---

### Batch 9.2 — Home Page Tile Sizing (CSS only)

**Goal:** Increase the vertical size of the news/events tiles on the home page.

- Locate the home page tile component (likely under `lib/components` or `lib/pages/home`).
- Adjust height / aspect-ratio / padding in its CSS-in-Dart styles only. No routing or data changes in this batch.
- Check at all breakpoints already established for the site, consistent with the per-page styling checkpoints used elsewhere.

**Definition of done:** Tiles are visibly taller, same content and data, checked in before moving to Batch 9.3.

---

### Batch 9.3 — News & Event Detail Pages: Routing & Rendering

**Goal:** Add routes and pages that render a single News item and a single Event item pulled from Sanity, mirroring the mobile app's detail screens.

- Add two routes, since News and Events are separate types: `/news/:slug` and `/events/:slug`.
- Add two `ContentRepository` methods — `getNewsItemBySlug(String slug)` and `getEventBySlug(String slug)` — rather than one shared method with branching logic.
- Build the News detail page: title, author/category if present, body, hero image.
- Build the Event detail page: title, date/start-end time, location, body, hero image.
- Reuse the existing Portable Text renderer already in the codebase for both pages' body content — no need to build a new one.
- Style with CSS-in-Dart; use the Claude Design template as visual reference only, not literal code.

**Definition of done:** Visiting `/news/<real-slug>` and `/events/<real-slug>` directly in the browser renders the correct content end-to-end from Sanity, using the existing Portable Text renderer.

---

### Batch 9.4 — Wire Up Tile Links (Home Page + /news)

**Goal:** Every News and Event tile, on both the home page and `/news`, links to its own working detail page.

- Home page tiles: replace whatever currently produces the WordPress link / dead link with a route to `/news/:slug` for News items or `/events/:slug` for Events, using the slug already present in the Sanity data the tile is built from.
- `/news` page tiles: same fix.
- If any PA Events tiles currently appear on either page, leave their linking behavior as-is for now — they're out of scope until PA Events is handled separately.
- Spot-check both a News tile and an Event tile on each page to confirm each resolves to the correct route.

**Definition of done:** Every News and Event tile on both pages navigates to a correctly populated detail page. No more references to the legacy WordPress URLs for this content.

---

### Scope Note

- PA Events is a related but separate Sanity document type. It is intentionally excluded from all four batches above and will be scoped as its own follow-up batch once News and Events are done.

## Batch 10 — Parent Association page + Current Families nav dropdown

Source of truth for content/behavior: https://littlevillage.org/parent-association/
Work one batch at a time, commit and check in before starting the next.

**Correction (pre-investigation batch text was wrong on two points):** the batch below
originally called for a `parentAssociation: bool` flag on the `event` schema. Investigation
(2026-08-04) found `~/dev/hlvs-studio/hlvs/schemaTypes/pa_event.js` already exists as its own
registered document type — `title`, `published_date`, `event_date`, `location`, `description`,
`google_meet` (optional), notably with **no required images**, unlike `event`. The existing
Flutter app already reads from it (`parent_association_screen.dart`,
`pa_events_provider.dart`, `pa_event_post_card.dart`, query `*[_type == "pa_event"]`). This also
matches Batch 9's own framing of PA Events as "a third, related Sanity document type." Decision:
**use the existing `pa_event` type, no boolean flag on `event`.** Also confirmed: the header nav
is a hardcoded array in `header.dart`, not driven by `SiteSettings.navigation` — 10.5 follows
that existing pattern, no schema change needed for nav.

### 10.1 — Sanity: PA content + PA events

- New singleton schema `parentAssociation`: `intro` (portable text), `duesAnnual` (string),
  `duesLifetime` (string), `signupUrl` (url), `boardMembers` (array of {role, name}),
  `contacts` (array of {name, email}).
- Do **not** add a flag to `event`. PA events already have their own type (`pa_event`, see
  correction note above) — leave `event` and its News/Events filter pills untouched.
- Seed the new `parentAssociation` singleton with the real content currently hardcoded in the
  Flutter app's `parent_association_screen.dart` (it isn't in Sanity yet, this is the point of
  the migration): intro copy, annual/lifetime dues ($20 / $100), the Give Lively signup URL,
  the 4 board members (role + name), and the 2 contacts (name + email). Pull current values from
  that file rather than re-typing from scratch or inventing placeholders.
- GROQ: query for the new `parentAssociation` singleton, and a `pa_event` list query (upcoming
  only, sorted ascending by `event_date`) — mirror the mobile app's existing query shape.
  Note (corrected during 10.3 implementation — the original note here had it backwards):
  `event_date` is a plain `date` field, not `datetime`. Verified against the live dataset that
  `dateTime(event_date) >= now()` is wrong — `dateTime()` on a bare date string returns `null`,
  so that filter silently matches nothing, ever. The plain comparison `event_date >= now()`
  is what actually works (GROQ compares the strings correctly). Don't add a `dateTime()` cast.
- Typed models: new `ParentAssociationInfo`; new `PaEventItem` (id, title, description,
  location, publishedDate, eventDate, meetingLink — mirrors the app's `PaEventPost`). Don't
  extend `EventItem`.
- Wire `getParentAssociationInfo()` and `getPaEvents()` through `ContentRepository`, same as
  every other content type.
- Verify: repository returns real data end-to-end (seed docs already present per above);
  confirm existing `event`/News-Events-filter queries and pages are unaffected.

### 10.2 — Parent Association page shell

- New route `/parent-association`, `lib/pages/parent_association.dart`.
- Intro via `portable_text_view`, dues line, prominent signup CTA (external link, new tab) to
  `signupUrl`, board members list, contacts list. Match Current Families/About visual style.
- Apply `seo_meta.dart` (title, description, canonical).
- No PA events section yet — that's 10.3.
- Verify: static build succeeds, content is live from Sanity (not hardcoded), SEO tags present,
  skip-link/landmark conventions from 7.5 followed.

### 10.3 — PA events section

- Add "Upcoming PA Events and Meetings" to the page, reusing the existing `CollectionCard`
  component (don't fork it) against the `getPaEvents()` query from 10.1. `pa_event` has no
  image field — `CollectionCard` already renders fine with `imageUrl: null`, no changes needed
  there.
- No detail pages for PA events in this batch — `pa_event` has no slug and Batch 9 already
  scoped PA Events routing as separate future work. Cards render info inline (title, date,
  location) without linking anywhere, same as the mobile app's card.
- Empty state: friendly message + fallback link to the school calendar (same pattern already
  used on Current Families), since Sanity may have zero upcoming PA events at any given time.
- Alt text / aria labeling per the 7.6 accessibility conventions.
- Verify: events render sorted correctly; temporarily empty the filter to confirm the empty
  state; calendar fallback link resolves.

### 10.4 — Current Families cross-link

**Correction (re-analysis, 2026-08-04):** two placeholder "Parent Association" links already
exist and point nowhere useful — [home.dart:249](lib/pages/home.dart#L249) (Current Families
band quicklink, currently routes to `/current-families` instead of a real destination) and
[current_families.dart:102](lib/pages/current_families.dart#L102) (`href: '#'` stub, plus a
stale comment at lines 29-33 claiming PA "has no Sanity content type yet"). Decision: fix these
two in place rather than adding a separate new teaser card — avoids ending up with three
different Parent Association links pointing to three different places.

- Repoint both existing quicklinks (`home.dart:249` and `current_families.dart:102`) to
  `/parent-association`.
- Delete/update the stale "no Sanity content type yet" comment in `current_families.dart`
  now that Parent Association has real content.
- No new card component — this batch is a link-destination fix, not a new UI element.
- Verify: both links resolve to `/parent-association`; mobile reflow checked at
  375/768/1024px per the 7.7 pattern.

### 10.5 — Nav: Current Families dropdown

**Correction (re-analysis, 2026-08-04):** originally specified a click/keyboard-toggle
`@client` dropdown, framed as if built in a separate desktop-nav surface and then "mirrored" in
`mobile_nav.dart`. In fact there is no separate desktop nav component — `header.dart` builds one
`navItems` list consumed entirely by the single `@client` `MobileNav` component, which renders
both the desktop CSS-hover dropdown and the mobile flyout from the same `_navItem` method
(mobile_nav.dart:101-123). A click-toggle for just this one item would've meant new per-item
open/close state in `_MobileNavState` (which currently only tracks the single hamburger
`_isOpen`) plus a CSS class scoped to avoid colliding with the shared `.nav-dropdown:hover`
rule. Decision: **reuse the existing hover/focus-within CSS pattern instead** — same interaction
model as Programs/About, no new `@client` state needed.

- Convert the flat "Current Families" header link into a dropdown with two entries:
  Overview (`/current-families`) and Parent Association (`/parent-association`) — add a
  `children` array to its entry in `header.dart`'s `navItems`, exactly like the existing
  Programs/About entries. The existing `hasDropdown`/`nav-dropdown`/`nav-dropdown-menu`
  handling in `mobile_nav.dart` already supports this generically — no new component or state.
- Add `'aliases': const ['/parent-association']` to the Current Families entry so the nav item
  shows active state while on `/parent-association`, matching how Programs/About's `aliases`
  keep them highlighted on child routes.
- Confirmed: the nav is a hardcoded array in `header.dart` (`SiteSettings.navigation` is queried
  but currently unused by the header). Follow that existing hardcoded-array pattern — don't
  introduce a Sanity-driven nav.
- Verify: dropdown opens/closes via mouse hover and keyboard focus (`:focus-within`) at desktop
  widths, same as Programs/About; mobile flyout shows it as a nested expandable item at
  375/768px; visiting `/parent-association` highlights "Current Families"; both links resolve.
