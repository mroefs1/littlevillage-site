# littlevillage-site

Replacement website for littlevillage.org (The Hagedorn Little Village School), moving off WordPress. Static marketing/content site: programs, staff, news, events, contact.

**Status:** Steps 1-8, 9 (News & Events detail pages), and 10 (Parent Association) are complete and live on the Cloudflare Pages preview. Full history of that work - including corrections and decisions made along the way - is archived in `docs/archive/completed-batches.md`. This file covers active/upcoming work only.

**Full plan and rationale:** see the "Little Village Site Rebuild - Jaspr + Sanity" Notion page.

## Tech stack (fixed, don't deviate without asking)
- **Jaspr** - Dart web framework, `mode: static` (SSG). Not an SPA, not SSR, for now.
- - **Styling:** Jaspr's native type-safe CSS-in-Dart (`css()`/`@css`/`Styles`). No CSS framework, no preprocessor.
  - - **Sanity** - CMS, source of truth for all content. Same project/dataset as the existing Dart app.
    - - **Cloudflare Pages** - static host. Confirmed working production host (littlevillage-site.pages.dev); custom domain cutover still pending.
      - - **Serverpod** - not yet. Future addition once genuinely dynamic/authenticated features are needed (donation flow, parent/staff portal). Contact form backend will NOT use Serverpod - see Deploy Pipeline below.
       
        - ## Guiding principles
        - - **Dart-first, minimal JS.** Avoid hand-written JS. Exceptions: Sanity client/tooling JS, and Cloudflare Pages Functions (which don't run Dart - see contact form below).
          - - **Content boundary:** Sanity owns all editable content. Jaspr owns layout/logic only.
            - - **Data layer:** never call the Sanity client directly from page components - always go through `ContentRepository` (`lib/sanity/`). This is what lets Serverpod slot in later without a content-layer rewrite.
              - - **Work in batches, one screen/task at a time.** Finish, verify, and commit one batch before starting the next. This has consistently caught real bugs early (see archive for examples) - keep it even with more usage budget available.
                - - **Nav is a hardcoded array in `header.dart`.** `SiteSettings.navigation` is queried but intentionally unused - follow the existing pattern, don't switch to Sanity-driven nav without discussing it first.
                 
                  - ## Active: Step 9b - Deploy Pipeline
                 
                  - Cloudflare Pages is already serving this preview build and is confirmed as the production host (`build.sh` installs the Dart SDK, since Cloudflare's build image doesn't ship one). Two real gaps remain: content freshness and the non-functional contact form.
                 
                  - - [ ] **9b.1 - Sanity webhook -> Cloudflare Pages Deploy Hook** - dashboard/console config on both sides, no code changes: a Cloudflare deploy hook triggered by a Sanity webhook on document publish/update/delete.
                    - [ ] - [ ] **9b.2 - Cloudflare Pages Function: contact form endpoint** - new `functions/api/contact.js` (the one deliberate JS exception to Dart-first, since Pages Functions don't run Dart). Validates submissions, sends via Resend API, reads the API key from a Cloudflare secret.
                    - [ ] - [ ] **9b.3 - Wire the contact form to the function** - convert the static Contact page into a real `@client` component with fetch-based submission, loading/success/error states, accessible error messaging.
                    - [ ] - [ ] **9b.4 - Production custom domain cutover** - add littlevillage.org as a custom domain on the Cloudflare Pages project, update DNS. Sequenced last, after 9b.2/9b.3 are verified working on the preview URL.
                   
                    - [ ] ## Open question
                    - [ ] `pages/support_us.dart` exists (added 2026-07-28, linked from the About dropdown) but isn't part of any documented batch, and the header's Donate pill still links to `href="#"`. Needs a decision: does Support Us replace the WordPress -> Give Lively Donate link, or is it separate? Where should the Donate pill point?
                   
                    - [ ] ## Reference: current WordPress nav (for parity-checking)
                    - [ ] Programs and Enrollment (+ Educational Programs, Early Intervention, Preschool, Elementary, Therapeutic Services, Family Services, CPSE Evaluations, Enrollment Info, Summer Rec) - About Us (+ Mission, History, Founders, Admin Staff, Board Members, Upcoming Events, Compliance, Data Privacy & Security, Career Opportunities) - School Facilities - Media (+ Newsletters, In The News, Videos, Pictures) - Contact - Donate (external, Give Lively)
                    - [ ] 
