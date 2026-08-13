import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';
import '../sanity/models/program.dart';
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
    ];

    const aboutLinks = [
      {'label': 'Mission', 'path': '/mission'},
      {'label': 'History', 'path': '/history'},
      {'label': 'Founders', 'path': '/founders'},
      {'label': 'Admin Staff', 'path': '/staff'},
      {'label': 'Board Members', 'path': '/board'},
      {'label': 'Compliance', 'path': '/compliance'},
      {'label': 'Data Privacy and Security', 'path': '/data-privacy-and-security'},
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
      {'label': 'Contact', 'path': '/contact'},
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
            div(classes: 'brand-name', [
              .text('The Hagedorn Little Village School'),
              div(classes: 'brand-subtitle', [.text('Jack Joel Center for Special Children')]),
            ]),
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
        fontSize: 12.px,
        backgroundColor: AppColors.navyDark,
      ),
      css('.utility-contact').styles(
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 13.px,
      ),
      // The full contact line is too long to wrap gracefully at mobile/
      // tablet widths — hidden there, keeping just the donate pill visible;
      // phone/email are still reachable via the Contact page and footer.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet), [
        css('&').styles(justifyContent: .end),
        css('.utility-contact').styles(display: .none),
      ]),
      css('.utility-actions', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: .all(12.px),
        ),
        css('.utility-social').styles(
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 14.px,
        ),
        css('.donate-pill').styles(
          padding: .symmetric(vertical: 5.px, horizontal: 14.px),
          radius: .all(.circular(Radii.pill)),
          color: Colors.white,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 14.px,
          fontWeight: .w700,
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
          fontSize: 18.px,
          fontWeight: .w700,
          lineHeight: 1.em,
        ),
        css('.brand-subtitle').styles(
          margin: .only(top: 2.px),
          color: AppColors.mutedTextLight,
          fontSize: 11.px,
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
          fontSize: 15.px,
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

        // Dropdown menus for Programs/About — pure CSS, toggled by
        // :hover and :focus-within (keyboard) on the nav item, no JS.
        css('.nav-dropdown').styles(position: .relative()),
        css('.nav-caret').styles(
          margin: .only(left: 3.px),
          fontSize: 11.px,
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
          fontSize: 14.px,
        ),
        css('.nav-dropdown-link:hover').styles(
          color: AppColors.blue,
          backgroundColor: AppColors.sky,
        ),
      ]),
    ]),
  ];
}
