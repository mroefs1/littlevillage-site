# Archived: Completed Batches (Steps 1-10)

Full history of completed work, moved out of CLAUDE.md on 2026-08-10 to keep the active working doc lean. Nothing here is active guidance — it's a record of decisions, corrections, and verification notes from each completed batch. See CLAUDE.md for current stack constraints, guiding principles, and active work.

## Steps 1-6: Scaffold through Programs & Enrollment

Scaffold (jaspr create, static build confirmed end-to-end) -> Layout shell (nav, footer, base template, shared CSS-in-Dart tokens) -> Sanity wiring (client, GROQ queries, typed models, all through a ContentRepository interface) -> Static pages (About, Mission, History, Founders, Facilities, Contact) -> Collections (News/events listing + detail, staff/board listing via jaspr_router) -> Programs & Enrollment (hub + 3 detail pages, age-bands via the category enum). All complete.

### Correction: Sass -> CSS-in-Dart
This plan originally called for Sass, on the assumption Jaspr had built-in .scss compilation via jaspr_builder. That's inaccurate - confirmed via Jaspr's docs that there's no built-in Sass pipeline. Using Jaspr's native CSS-in-Dart system instead (css()/@css/Styles from package:jaspr/jaspr.dart), which is also more consistent with the Dart-first/minimal-JS approach. Sass remains an option in principle but isn't the default - don't add a Sass toolchain without discussing it first.

## Design Handoff Restyling (7/7 batches complete)
All pages from the Claude Design handoff (design_handoff_homepage_admissions 2/) restyled from placeholder content to final design:
- Homepage - hero, trust strip, age-locator cards, enrollment teaser, latest news/events, Current Families band, donate band
- - Admissions - eligibility checklist, 4-step journey, $0 callout, FAQ accordion (@client component), CTA band
  - - Programs hub + 3 detail pages - data-driven routes per program slug
    - - About redesign - inline stats/mission/team/accreditation; Mission/History/Founders/Staff/Board kept reachable via a compact sub-nav row
      - - Contact redesign - two-column form + info card pulling phone/email from SiteSettings; form itself static/non-functional pending a backend (later solved in Step 9b)
        - - News & Events additions - client-side filter pills, newsletter download links from Sanity
          - - Current Families - new page/route; ParentDocument model wired to the doc Sanity type; calendars embedded via iframe per CLAUDE.md guidance, not modeled in Sanity; added to primary nav
           
            - ## Step 7: Polish (8/8 batches complete)
            - - 7.1 - 404 Page - custom not-found route styled with site chrome, link back to homepage
              - - 7.2 - SEO meta helper (seo_meta.dart: title, description, canonical, OG tags, favicon) applied to Home, About family, Contact, Current Families
                - - 7.3 - SEO meta extended to Programs hub + 3 detail pages, News/Events, Staff/Board, with dynamic per-item title/description
                  - - 7.4 - Sitemap + robots.txt - build-time sitemap.xml covering every route, robots.txt referencing it
                    - - 7.5 - Accessibility: layout & navigation - skip-to-content link, landmark roles, keyboard focus states, color-contrast fixes
                      - - 7.6 - Accessibility: page content & components - alt text, heading hierarchy, form labels, ARIA states on FAQ accordion and filter pills
                        - - 7.7 - Mobile responsiveness: core pages - Home, Admissions, About, Contact, Current Families at 375/768/1024px; new Breakpoints token set and @client hamburger nav (mobile_nav.dart)
                          - - 7.8 - Mobile responsiveness: collections & programs - found and fixed a real overflow bug (program cards not wrapping) and a subtler align-items/stretch bug shrinking a photo box on mobile
                           
                            - Dev note: jaspr serve's default debug mode hardcodes hot-reload to localhost, which breaks the debug JS bundle on a real phone over LAN (not just hot-reload). Use jaspr serve --release when testing on an actual device.
                           
                            - ## Step 8: Home Hero Redesign (5/5 batches complete)
                            - Two-column homepage hero: text stays in the left 50%, right 50% gets an auto-scrolling Sanity-driven photo gallery replacing the old placeholder image. Pauses on hover, manual arrows, hidden entirely on mobile.
                            - - 8.1 - Two-column hero shell (desktop) - grid/flex 50/50 split, text moved into left column unchanged, placeholder removed
                              - - 8.2 - Sanity: heroGallery array-of-images field on siteSettings (each with required alt text), GROQ + typed model extended, wired through ContentRepository
                                - - 8.3 - Gallery component (components/hero_gallery.dart) - renders heroGallery via ContentRepository; handles empty/unpopulated gallery gracefully
                                  - - 8.4 - Motion: auto-scroll with seamless loop, hover-pause/resume, manual prev/next arrows with aria-labels, built as a Jaspr @client island (not hand-written JS), respects prefers-reduced-motion
                                    - - 8.5 - Mobile: gallery hidden at mobile breakpoints via existing Breakpoints tokens, text column goes full-width with no dead space
                                     
                                      - ## Step 9: News & Events Tiles + Detail Pages (4/4 batches complete)
                                      - Problem: home-page news/events tiles were too short, and either dead-linked to the legacy WordPress site or linked nowhere; no detail page existed for an individual item. Modeled on the mobile app's existing single-document fetch + detail-screen approach.
                                      - Confirmed decisions: News and Events are separate Sanity document types with different fields (not a shared type + variant flag). PA Events are a third, related type, explicitly out of scope for this batch. No legacy URL redirect mapping needed (clean break). Portable Text rendering reused, not rebuilt.
                                      - - 9.1 - Sanity field audit (no code) - confirmed exact field names for News and Events document types, slug patterns, reused mobile app's existing GROQ queries as reference
                                        - - 9.2 - Home tile sizing (CSS only) - taller tiles, no data/routing changes
                                          - - 9.3 - Detail routing & rendering - /news/:slug and /events/:slug routes, getNewsItemBySlug() and getEventBySlug() as two separate ContentRepository methods (not one branching method), reusing the existing Portable Text renderer
                                            - - 9.4 - Wire up tile links - home page and /news tiles now route to real detail pages instead of legacy WordPress links; PA Events tiles left untouched (separate future scope)
                                             
                                              - ## Step 10: Parent Association page + Current Families nav dropdown (5/5 batches complete)
                                              - Source of truth for content/behavior: littlevillage.org/parent-association/.
                                             
                                              - ### Correction (pre-investigation batch text was wrong on two points)
                                              - The original plan called for a parentAssociation: bool flag on the event schema. Investigation (2026-08-04) found ~/dev/hlvs-studio/hlvs/schemaTypes/pa_event.js already exists as its own registered document type (title, published_date, event_date, location, description, optional google_meet, notably no required images, unlike event) - the existing Flutter app already reads from it (parent_association_screen.dart, pa_events_provider.dart, pa_event_post_card.dart, query *[_type == "pa_event"]). Decision: use the existing pa_event type, no boolean flag on event. Also confirmed: the header nav is a hardcoded array in header.dart, not driven by SiteSettings.navigation - 10.5 follows that existing pattern, no schema change needed.
                                             
                                              - - 10.1 - Sanity: PA content + PA events - new parentAssociation singleton (intro portable text, duesAnnual $20, duesLifetime $100, signupUrl, boardMembers array, contacts array), seeded from the Flutter app's hardcoded content in parent_association_screen.dart. New ParentAssociationInfo and PaEventItem models (not extending EventItem), both wired through ContentRepository. Note: event_date on pa_event is a plain date field, not datetime - dateTime(event_date) >= now() silently matches nothing (dateTime() on a bare date string returns null); the plain string comparison event_date >= now() is what actually works.
                                                - - 10.2 - Parent Association page shell - /parent-association route, lib/pages/parent_association.dart: intro via portable_text_view, dues line, signup CTA (external, new tab), board members list, contacts list, seo_meta.dart applied, matches Current Families/About visual style
                                                  - - 10.3 - PA events section - "Upcoming PA Events and Meetings" reusing the existing CollectionCard component (unforked) against getPaEvents(); renders fine with imageUrl: null since pa_event has no image field. No detail pages/slugs for PA events (out of scope, see Step 9 scope note). Empty state: friendly message + fallback link to school calendar.
                                                    - - 10.4 - Current Families cross-link - correction (re-analysis 2026-08-04): two placeholder Parent Association links already existed pointing nowhere useful - home.dart:249 (routed to /current-families instead of PA) and current_families.dart:102 (href: '#' stub, plus a stale comment claiming PA had no Sanity type yet). Decision: fix both in place rather than add a new teaser card, to avoid three different PA links pointing to three different places.
                                                      - - 10.5 - Nav: Current Families dropdown - correction (re-analysis 2026-08-04): no separate desktop-nav component exists - header.dart builds one navItems list consumed entirely by a single @client MobileNav component, which renders both the desktop CSS-hover dropdown and the mobile flyout from the same _navItem method. Decision: reuse the existing hover/focus-within CSS pattern (same as Programs/About) instead of building new click-toggle state. Added children array to the Current Families nav entry plus aliases: ['/parent-association'] so the nav item shows active state on the PA page. Nav remains a hardcoded array in header.dart by design.
                                                        - 
