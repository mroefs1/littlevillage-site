# Handoff: Little Village School — Homepage & Admissions

## Overview
Redesign of littlevillage.org, a special-education school site (publicly funded, ages birth–12). The current WordPress site skews toward existing parents; this redesign re-centers the homepage and a new Admissions page on prospective families researching enrollment, while preserving donation and news/events prominence for fundraising, and giving current parents a clear home for the calendar and documents.

## About the Design Files
The two HTML files in this bundle (`homepage.html`, `admissions.html`) are **design references** — static prototypes showing intended layout, content, and visual structure. They are not production code. The task is to **recreate these designs in the project's actual stack**: Serverpod (Dart backend) + Jaspr (Dart frontend) + SASS for styling. Reimplement the layout as Jaspr components with SASS stylesheets (not inline styles), wiring real data (news/events, calendar, documents) through Serverpod endpoints instead of the placeholder content shown here.

## Fidelity
**Low-fidelity wireframes.** Structure, hierarchy, and copy direction are intentional; exact colors/fonts are placeholders, not final brand values. Treat placeholder-photo blocks (dashed border, diagonal hatch, labeled text) as slots for real photography. Apply final brand typography and palette during implementation — the two colors used here (`#2f5aa8` blue, `#d97a2b` warm orange) are suggested primary/accent directions, not confirmed brand colors.

## Screens / Views

### 1. Homepage (`homepage.html`)
**Purpose:** First stop for a parent who suspects their child needs services. Primary goal: get them to "Request Information" or "Schedule a Tour." Secondary: keep donation and news/events visible; give returning families a fast path to calendar/documents.

**Layout (top to bottom):**
- Utility bar: phone, email, location (left) + social icons + Donate button (right). `padding: 7px 40px`, light blue bg `#eef2f8`.
- Primary nav: logo mark + school name/subtitle (left), nav links + "Request Info" button (right). `padding: 14px 40px`.
- Hero: two-column flex, ~1.05:1 ratio. Left: eyebrow pill, H1, supporting paragraph (max-width 430px), two CTAs ("Request Information" primary filled blue, "Schedule a Tour" secondary outlined). Right: photo placeholder, 280px tall.
- Trust strip: 4-column bordered row, each cell centered — "$0 cost to families", "50+ years serving Long Island", "Birth–12 EI → Elementary", "On-site integrated therapy".
- Self-locate-by-age: centered H2, then 3 equal-width cards (Birth–3 / 3–5 / 5–12), each with photo placeholder, age label, program name, one-line description, "Learn more" link.
- "How enrollment works" teaser: shaded box with 4 numbered mini-steps in a row, linking to full Admissions page.
- News & Events: two-column split — "Latest News" (list of thumbnail + title + date) and "Upcoming Events" (date-badge + title).
- **Current Families band** (new): bordered card, header "Already part of Little Village? Welcome back." + "Parent portal →" link. Three columns: School Calendar (icon, description, "View calendar →"), Important Documents (icon, description, "Browse documents →"), and a stacked link list (Parent Association, Summer Recreation, Careers & staff portal).
- Donate band: warm tan/orange bordered box, message + "♥ Donate" button, right-aligned button.
- Footer: dark navy `#2b3550`, school name/address (left), 3 link columns (Programs, Get started, Community) (right).

**Components — key styling values:**
- Font: headings/labels/buttons in "Gaegu" (rounded, friendly, bold 700); body copy in system-ui.
- Primary blue: `#2f5aa8`. Accent/donate orange: `#d97a2b`. Body text gray: `#6b6760`. Borders: `#ece9e1` / `#c9c4b8`.
- Buttons: `border-radius: 9px`, bold Gaegu label, `padding: 13px 22px` (primary), 2px outline variant for secondary.
- Cards/sections: `border-radius: 8–12px`, `border: 2px solid`, generous internal padding (16–24px).

### 2. Admissions / How to Enroll (`admissions.html`)
**Purpose:** Conversion page — demystify the EI/CPSE/IEP process and drive action.

**Layout (top to bottom):**
- Compact nav (logo + links, current page underlined, Donate button).
- Breadcrumb ("Home › Admissions") + H1 + supporting paragraph.
- Eligibility quick-check: bordered card, header "Is my child eligible?", 3-column checklist (residency, age range, diagnosed/suspected delay), footer strip with phone number for uncertain visitors.
- "The enrollment journey": 4 stacked step cards, each with numbered circle badge (filled blue), title, description, and a photo placeholder thumbnail (90×60px) at the right.
- "$0 tuition" callout: light-blue bordered box, large "$0" figure + explanation of public funding.
- FAQ: accordion list, 4 questions, one shown expanded by default with answer text.
- Big CTA band: solid blue `#2f5aa8` rounded panel, headline + subtext + three CTAs (Request Information filled white, Schedule a Tour outlined white, Call [number] outlined lighter blue).
- Footer: same as homepage, with "Get started" and "Community" link columns.

## Interactions & Behavior
- Nav links, footer links: standard navigation (no special behavior specified).
- "Request Information" / "Schedule a Tour": should route to a lead-capture form (form fields not yet designed — flag this as an open item for the next design pass, likely: parent name, child's age/DOB, phone/email, brief note, county/district if known).
- FAQ accordion: click to expand/collapse; only one shown open in the mock, others collapsed (`+` vs `–` glyph indicates state).
- Donate button: links to a donation/payment flow (existing system, not designed here).
- Parent portal link: routes to existing/new parent-authenticated area (out of scope for these two pages).
- All interactive targets should be ≥44px tall for accessibility (touch targets), and hover/focus states should be added during implementation — none are shown in the static mock but should follow standard patterns (visible focus ring, subtle darken/lift on hover for buttons and cards).

## State Management
Not applicable to these static pages beyond the FAQ accordion's open/closed state. Data-backed sections (News, Events, Calendar, Documents) will need to fetch from Serverpod endpoints — see Assets/Data below.

## Design Tokens (placeholder values — confirm final brand palette before build)
- Primary blue: `#2f5aa8`
- Accent/warm orange (donate): `#d97a2b`
- Ink/heading: `#2c2a26`
- Body gray: `#6b6760`
- Muted gray: `#8a8578`
- Light blue tint (bg): `#eef2f8`
- Warm tint (donate bg): `#f6e7d6` / border `#e7c79f`
- Neutral border: `#ece9e1` (light) / `#c9c4b8` (medium)
- Footer navy: `#2b3550`
- Border radius scale: 6–12px depending on component size
- Spacing: page gutters 40px; section vertical rhythm ~24–30px; card padding 16–24px
- Headline/label font: "Gaegu" (Google Font, weights 400/700)
- Body font: system-ui / -apple-system / sans-serif

## Assets
- Photo placeholders throughout (hatched pattern + dashed border) need real photography: hero (child + teacher classroom moment), age-group cards (3), facilities/campus.
- Icon glyphs currently emoji (📅, 📄, ♥, 📞) — replace with a consistent icon set matching final brand.
- Font loaded via Google Fonts CDN link in each file's `<head>` — replace with self-hosted fonts or the project's font pipeline if CDN fonts aren't desired.
- Data-backed content to wire up via Serverpod: Latest News items, Upcoming Events, School Calendar, Important Documents list.

## Files
- `homepage.html` — full static reference for the homepage.
- `admissions.html` — full static reference for the Admissions page.
- `screenshots/01-05-homepage.png` — scrolled captures of the homepage, top to bottom.
- `screenshots/01-05-admissions.png` — scrolled captures of the Admissions page, top to bottom.
- Both HTML files are self-contained (open directly in a browser, no build step) and share the same visual language — implement as a shared Jaspr layout/nav/footer component set with SASS partials for colors, spacing, and typography.
