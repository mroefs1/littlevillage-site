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
7. **Current Families** (new page/route) — needs a `Document` model/query wired to the existing `doc` Sanity type (unused so far), plus a real gap: no lightweight "calendar closure/key date" content type yet (`event` requires two images, wrong shape for simple closures). Kept out of primary nav per the handoff; linked from footer/homepage band. Suggest embedding google calendar instead of pulling that information from Sanity. The app uses that approach.

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
