import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';
import '../sanity/models/program.dart';
import 'accessibility_panel.dart';
import 'language_switcher.dart';
import 'mobile_nav.dart';

// Same three age-band categories, in the same display order, as the
// Programs hub (pages/programs.dart) — the Programs dropdown mirrors that
// page's card ordering rather than raw Sanity document order.
const _ageBandCategories = ['Early Intervention', 'Preschool', 'Elementary'];

class Header extends StatelessComponent {
  final List<Program> programs;

  const Header({required this.programs, super.key});

  @override
  Component build(BuildContext context) {
    var activePath = context.url;

    final programLinks = [
      for (final category in _ageBandCategories)
        for (final program in programs)
          if (program.category == category) {'label': program.title, 'path': '/programs/${program.slug}'},
      // Not an age-band `program` document — a standalone content page, so
      // it's appended here rather than driven by the category loop above.
      {'label': 'Therapeutic Services', 'path': '/programs/therapeutic-services'},
      {'label': 'Family Services', 'path': '/programs/family-services'},
      {'label': 'CPSE Evaluations', 'path': '/programs/cpse-evaluations'},
      {'label': 'Summer CARP', 'path': '/programs/summer-carp'},
    ];

    const aboutLinks = [
      {'label': 'Mission', 'path': '/mission'},
      {'label': 'History', 'path': '/history'},
      {'label': 'Founders', 'path': '/founders'},
      {'label': 'Admin Staff', 'path': '/staff'},
      {'label': 'Board Members', 'path': '/board'},
      {'label': 'Compliance', 'path': '/compliance'},
      {'label': 'Data Privacy and Security', 'path': '/data-privacy-and-security'},
      {'label': 'Career Opportunities', 'path': '/careers'},
      {'label': 'Accessibility', 'path': '/accessibility'},
    ];

    // Nav data is handed to `MobileNav` (the @client hydration boundary for
    // the hamburger toggle) as plain Maps rather than the previous record
    // typedef, since @client component params must be JSON-serializable.
    final navItems = [
      {
        'label': 'Programs',
        'path': '/programs',
        'aliases': [for (final link in programLinks) link['path']],
        'children': programLinks,
      },
      {'label': 'Admissions', 'path': '/admissions'},
      {
        'label': 'About',
        'path': '/about',
        'aliases': const [
          '/mission',
          '/history',
          '/founders',
          '/staff',
          '/board',
          '/compliance',
          '/data-privacy-and-security',
          '/careers',
          '/accessibility',
        ],
        'children': aboutLinks,
      },
      {'label': 'Facilities', 'path': '/facilities'},
      {
        'label': 'News & Events',
        'path': '/news',
        'aliases': const ['/events'],
      },
      {
        'label': 'Current Families',
        'path': '/current-families',
        'aliases': const ['/parent-association'],
        'children': const [
          {'label': 'Overview', 'path': '/current-families'},
          {'label': 'Parent Association', 'path': '/parent-association'},
        ],
      },
      // Fourth dropdown, matching the legacy nav's own Media menu. Pictures
      // is deliberately absent — the legacy version is a WordPress category
      // archive, dropped for now.
      {
        'label': 'Media',
        'path': '/media',
        'aliases': const ['/media/newsletters', '/media/in-the-news', '/media/videos'],
        'children': const [
          {'label': 'Newsletters', 'path': '/media/newsletters'},
          {'label': 'In The News', 'path': '/media/in-the-news'},
          {'label': 'Videos', 'path': '/media/videos'},
        ],
      },
      // No 'Contact' item: the nav's own pill links to /contact and is
      // labelled "Contact", so a separate entry was redundant (decided
      // 2026-08-25).
      {'label': 'Support Us', 'path': '/support-us'},
    ];

    // Both the utility bar and the main brand/nav row live inside one
    // `<header>` landmark — they're both top-of-page site chrome, and
    // splitting them left the utility bar's contact/social/donate links
    // outside any landmark (flagged by axe's "region" rule).
    return header([
      div(classes: 'utility-bar', [
        div(classes: 'utility-contact', [
          .text('📞 516-520-6000 · ✉ information@littlevillage.org · Seaford, NY'),
        ]),
        div(classes: 'utility-actions', [
          // In the utility bar rather than the nav row: that row is already
          // tight enough that `Breakpoints.nav` has been re-measured twice,
          // and `.utility-actions` stays visible at every width (only
          // `.utility-contact` hides at tablet), so the switcher stays
          // reachable on mobile without disturbing that breakpoint.
          const LanguageSwitcher(),
          const AccessibilityPanel(),
          span(classes: 'utility-social', [.text('f ▸ ◎')]),
          Link(to: '/support-us', classes: 'donate-pill', child: .text('♥ Donate')),
        ]),
      ]),
      div(classes: 'header-main', [
        Link(
          to: '/',
          classes: 'brand',
          child: .fragment([
            img(src: '/images/brand-mark.png', alt: 'Hagedorn Little Village School logo', classes: 'brand-mark'),
            // The school's name and its center's name are proper nouns,
            // exempted from machine translation so they stay constant in
            // every language. Without this, Arabic rendered the name as a
            // transliteration no family could search for or say aloud to a
            // receptionist.
            div(
              classes: 'brand-name notranslate',
              attributes: const {'translate': 'no'},
              [
                .text('The Hagedorn Little Village School'),
                div(classes: 'brand-subtitle', [.text('Jack Joel Center for Special Children')]),
              ],
            ),
          ]),
        ),
        MobileNav(activePath: activePath, items: navItems),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.utility-bar', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 7.px, horizontal: 40.px),
        justifyContent: .spaceBetween,
        alignItems: .center,
        color: Colors.white,
        fontSize: 0.75.rem,
        backgroundColor: AppColors.navyDark,
      ),
      css('.utility-contact').styles(
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 0.8125.rem,
      ),
      // The full contact line is too long to wrap gracefully at mobile/
      // tablet widths — hidden there, keeping just the donate pill visible;
      // phone/email are still reachable via the Contact page and footer.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet), [
        css('&').styles(justifyContent: .end),
        css('.utility-contact').styles(display: .none),
      ]),
      // At 375px the bar's three actions need exactly the width its 40px
      // side padding leaves, so the social icons and donate pill wrapped to
      // a second line once the language switcher joined them. Dropping to
      // 20px here also brings this bar in line with every content section,
      // which has always used 20px at mobile while this one kept 40px.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('&').styles(padding: .symmetric(vertical: 7.px, horizontal: 20.px)),
        css('.utility-actions').styles(gap: .all(10.px)),
        // These are placeholder glyphs, not links - there are no social
        // accounts wired up behind them. With the language switcher and the
        // display panel both in this bar there is no room for decoration at
        // phone widths, and dropping them is the only change here that costs
        // a visitor nothing.
        css('.utility-social').styles(display: .none),
      ]),
      css('.utility-actions', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: .all(12.px),
        ),
        css('.utility-social').styles(
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.875.rem,
          // Flex can shrink this below its intrinsic width on very narrow
          // phones, which wraps the icon run onto a second line and makes
          // the whole bar taller. It's five characters — never wrap it.
          whiteSpace: .noWrap,
        ),
        css('.donate-pill').styles(
          padding: .symmetric(vertical: 5.px, horizontal: 14.px),
          radius: .all(.circular(Radii.pill)),
          color: Colors.white,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.875.rem,
          fontWeight: .w700,
          // A pill that wraps stops reading as a pill. Its homepage
          // counterpart (`.donate-band-button`) already sets this; the
          // header copy never did, and flex shrink can wrap it on very
          // narrow phones.
          whiteSpace: .noWrap,
          backgroundColor: AppColors.coral,
        ),
        // White outline, not the sitewide blue — against this dark navy
        // utility-bar background, blue only clears ~2:1 contrast, well
        // under the 3:1 WCAG floor for a visible focus indicator (same
        // reasoning as the footer's focus-visible override).
        css('.donate-pill:focus-visible').styles(
          outline: Outline(color: Colors.white, width: OutlineWidth(2.px), style: .solid),
          raw: {'outline-offset': '2px'},
        ),
      ]),
    ]),
    css('header', [
      css('.header-main').styles(
        display: .flex,
        position: .relative(),
        padding: .symmetric(vertical: 14.px, horizontal: 40.px),
        border: .only(
          bottom: .solid(color: AppColors.line, width: 2.px),
        ),
        justifyContent: .spaceBetween,
        alignItems: .center,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('.header-main').styles(
          padding: .symmetric(vertical: 12.px, horizontal: 20.px),
        ),
      ]),
      css('.brand', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: .all(11.px),
        ),
        css('.brand-mark').styles(
          display: .block,
          width: 48.px,
          height: 48.px,
          raw: {'object-fit': 'contain'},
        ),
        css('.brand-name').styles(
          color: AppColors.navy,
          fontFamily: .list([headingFontFamily, FontFamilies.serif]),
          fontSize: 1.125.rem,
          fontWeight: .w700,
          lineHeight: 1.em,
        ),
        css('.brand-subtitle').styles(
          margin: .only(top: 2.px),
          color: AppColors.mutedTextLight,
          fontSize: 0.6875.rem,
          fontWeight: .w400,
        ),
      ]),
      css('.brand:focus-visible').styles(
        outline: Outline(color: AppColors.blue, width: OutlineWidth(2.px), style: .solid),
        raw: {'outline-offset': '3px'},
      ),
      css('nav', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: .all(20.px),
        ),
        css('a').styles(
          color: AppColors.blue,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.9375.rem,
          fontWeight: .w600,
        ),
        css('a:focus-visible').styles(
          radius: .all(.circular(4.px)),
          outline: Outline(color: AppColors.blue, width: OutlineWidth(2.px), style: .solid),
          raw: {'outline-offset': '3px'},
        ),
        css('div.active').styles(
          position: .relative(),
        ),
        css('div.active::before').styles(
          content: '',
          display: .block,
          position: .absolute(bottom: (-6).px, left: 0.px, right: 0.px),
          height: 2.px,
          radius: .circular(1.px),
          backgroundColor: AppColors.blue,
        ),
        css('.request-info').styles(
          padding: .symmetric(vertical: 10.px, horizontal: 18.px),
          radius: .all(.circular(Radii.pill)),
          color: Colors.white,
          fontWeight: .w700,
          backgroundColor: AppColors.coral,
        ),

        // Dropdown menus for Programs/About/Current Families/Media — pure
        // CSS, toggled by :hover and :focus-within (keyboard) on the nav
        // item, no JS.
        //
        // `white-space: nowrap` matters: adding Media as a fourth dropdown in
        // Step 21 pushed the row wide enough that "Current Families" broke
        // onto two lines, leaving that one item 42px tall against its
        // neighbours' 21px and visibly misaligning the whole row. A top-level
        // nav label should never wrap.
        // Two separate rules, and `&`-relative: this block is nested under
        // `css('nav', ...)` and `.primary-nav` IS that <nav>, so a
        // `.primary-nav > div` selector here compiles to
        // `header nav .primary-nav > div` and never matches. Jaspr also only
        // prefixes the FIRST selector in a comma-separated list, so combining
        // these two would silently leave the second one unscoped.
        css('& > div').styles(whiteSpace: .noWrap),
        css('& > a').styles(whiteSpace: .noWrap),
        css('.nav-dropdown').styles(position: .relative()),
        css('.nav-caret').styles(
          margin: .only(left: 3.px),
          fontSize: 0.6875.rem,
        ),
        css('.nav-dropdown-menu').styles(
          display: .none,
          position: .absolute(top: 100.percent, left: 0.px),
          minWidth: 190.px,
          padding: .all(8.px),
          border: .all(color: AppColors.line, width: 2.px),
          radius: .all(.circular(Radii.sm)),
          shadow: BoxShadow(offsetX: 0.px, offsetY: 8.px, blur: 20.px, color: .rgba(23, 51, 74, 0.14)),
          flexDirection: .column,
          gap: .all(2.px),
          backgroundColor: Colors.white,
          raw: {'z-index': '30'},
        ),
        css('.nav-dropdown:hover > .nav-dropdown-menu, .nav-dropdown:focus-within > .nav-dropdown-menu').styles(
          display: .flex,
        ),
        css('.nav-dropdown-link').styles(
          padding: .symmetric(vertical: 8.px, horizontal: 12.px),
          radius: .all(.circular(Radii.sm)),
          color: AppColors.navy,
          fontSize: 0.875.rem,
        ),
        css('.nav-dropdown-link:hover').styles(
          color: AppColors.blue,
          backgroundColor: AppColors.sky,
        ),
      ]),
    ]),
  ];
}
