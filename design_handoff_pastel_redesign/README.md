# Handoff: Pastel/Fraunces Restyle — Hagedorn Little Village School site

## Overview
A visual restyle of the littlevillage-site.pages.dev site: new type pairing and a pastel color palette, applied to the site's existing page structure and content. No layout, IA, or copy changes are intended — this is a skin change.

## About the Design Files
The files in this bundle (`home.html`, `admissions.html`, `contact.html`) are **design references built in plain HTML/CSS** — they show the intended look, colors, type, and component styling. They are not production code to drop in. The task is to **recreate this styling in the site's actual codebase** (whatever templating/CMS/framework it runs on — this looks like a static/Jamstack site, possibly with a headless CMS given the `cdn.sanity.io` image URLs seen live) using its existing build system, templates, and content structure. Apply the same tokens and component patterns to every page and template on the site (Programs, Early Intervention, Preschool, Elementary, About, Mission, History, Founders, Admin Staff, Board, Facilities, News, Current Families, Parent Association, etc.), not just the three pages mocked up here.

## Fidelity
**High-fidelity** for the token system (colors, type, radii, spacing) and for the component patterns shown (nav, hero, cards, steps, FAQ, forms, footer). The three HTML files are pixel-accurate references for those patterns — reuse the same patterns on every other page rather than re-deriving styles.

## Reference pages included
1. **home.html** — homepage: utility bar, nav, hero w/ rotating photo gallery + stat strip, "start by age" 3-card picker, enrollment steps, news/events row, "Already part of Little Village" resource band, donate banner, footer.
2. **admissions.html** — admissions: breadcrumb, header, eligibility checklist, 4-step enrollment journey, $0-tuition callout, FAQ accordion, closing CTA, footer.
3. **contact.html** — contact: breadcrumb, header, two-column layout (inquiry form + contact details/map), footer.

Every other page on the site should inherit the same header/utility-bar/footer chrome and the same component styles (cards, step numbers, pill buttons, FAQ rows, etc.) shown in these three.

## Design Tokens

### Color
| Token | Hex | Use |
|---|---|---|
| navy (ink/text) | `#17334a` | primary text |
| navy-dark | `#143c55` / `#102f43` | header bars, footer bg |
| blue | `#356e8d` | nav links, secondary text accents |
| sky | `#eaf5f8` | light banded sections |
| cream | `#fffaf2` | section background |
| coral (accent/CTA) | `#ef7d68` | primary buttons, links, active accents |
| peach | `#fff0e8` / `#fde3d5` | card backgrounds, icon tiles |
| green | `#4e8b75` | check icons |
| mint | `#e7f3ed` / `#d9ecdf` | card backgrounds, icon tiles |
| yellow | `#f5c75f` | step-number circles, small highlights |
| line/border | `#dce7eb` / `#cbdbe2` | borders, dividers |
| muted text | `#4e6879` / `#546b78` / `#728591` | body copy, secondary text |

Max 2 background colors dominate any one page (white/cream + one pastel band); coral is the only saturated accent used for calls to action.

### Typography
- **Headings:** Fraunces (serif), weight 500–700, tight letter-spacing (-0.015em to -0.02em) on H1/H2.
- **Body/UI:** DM Sans, weight 400–700.
- Google Fonts import: `family=DM+Sans:wght@400;500;600;700&family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700`

### Shape & spacing
- Card radius: 20–28px. Pill buttons: `border-radius:999px`.
- Section vertical padding: ~56–72px.
- Buttons: coral fill for primary CTA, white/outline (`2px solid #dce7eb`) for secondary.

## Interactions & Behavior
- Hero has a rotating photo gallery (carousel) — dots indicator shown; actual site auto-rotates multiple photos (`selectors: cdn.sanity.io` images on live site).
- FAQ accordion on Admissions: one item shown expanded (`–`), rest collapsed (`+`); click toggles expand/collapse.
- Nav dropdowns exist on the live site for Programs/About/Current Families (not detailed in these mocks — carry over the live site's existing dropdown behavior).
- Contact form fields: required fields marked `*`; "Phone or email required" is a conditional validation rule (at least one of phone/email must be filled).
- Buttons/links: standard hover state should lighten/darken by ~8–10%; no other custom motion specified.

## State Management
Static content pages — no client state beyond standard form field state and the FAQ accordion's open/closed state and hero carousel's current-slide index.

## Assets
- No real photography included — hero and news thumbnails are striped placeholder blocks with a monospace label, standing in for photos that already exist on the live site (served from `cdn.sanity.io`). Pull the actual photos from the CMS when implementing.
- Icons are plain emoji glyphs (📞 ✉ 📍 🕐 📅 📄 ♥) — replace with the site's icon system if it has one, or keep as-is.

## Files
- `home.html` — homepage reference (screenshot: `screenshots/home.png`)
- `admissions.html` — admissions page reference (screenshot: `screenshots/admissions.png`)
- `contact.html` — contact page reference (screenshot: `screenshots/contact.png`)

The original in-browser comparison mockups (current style vs. this proposed style, plus more page examples) live in the project as `Homepage Comparison.dc.html` if further reference is needed.
