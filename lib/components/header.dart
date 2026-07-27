import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';
import '../sanity/models/program.dart';

typedef _NavChild = ({String label, String path});

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
          if (program.category == category) (label: program.title, path: '/programs/${program.slug}'),
    ];

    const aboutLinks = [
      (label: 'Mission', path: '/mission'),
      (label: 'History', path: '/history'),
      (label: 'Founders', path: '/founders'),
      (label: 'Admin Staff', path: '/staff'),
      (label: 'Board Members', path: '/board'),
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
          a(href: '#', classes: 'donate-pill', [.text('♥ Donate')]),
        ]),
      ]),
      div(classes: 'header-main', [
        Link(
          to: '/',
          classes: 'brand',
          child: .fragment([
            div(classes: 'brand-mark', [.text('LV')]),
            div(classes: 'brand-name', [
              .text('Hagedorn Little Village School'),
              div(classes: 'brand-subtitle', [.text('Jack Joel Center for Special Children')]),
            ]),
          ]),
        ),
        nav(attributes: const {'aria-label': 'Primary'}, [
          _navItem(
            label: 'Programs',
            path: '/programs',
            activePath: activePath,
            aliases: [for (final link in programLinks) link.path],
            children: programLinks,
          ),
          _navItem(label: 'Admissions', path: '/admissions', activePath: activePath),
          _navItem(
            label: 'About',
            path: '/about',
            activePath: activePath,
            aliases: const ['/mission', '/history', '/founders', '/staff', '/board'],
            children: aboutLinks,
          ),
          _navItem(label: 'Facilities', path: '/facilities', activePath: activePath),
          _navItem(label: 'News & Events', path: '/news', activePath: activePath, aliases: const ['/events']),
          _navItem(label: 'Current Families', path: '/current-families', activePath: activePath),
          _navItem(label: 'Contact', path: '/contact', activePath: activePath),
          Link(to: '/contact', classes: 'request-info', child: .text('Request Info')),
        ]),
      ]),
    ]);
  }

  // Plain nav link, or — when `children` is non-empty — a nav item with a
  // pure-CSS (`:hover`/`:focus-within`, see styles below) dropdown menu, so
  // Programs/About sub-pages are reachable without leaving the top nav.
  static Component _navItem({
    required String label,
    required String path,
    required String activePath,
    List<String> aliases = const [],
    List<_NavChild> children = const [],
  }) {
    final hasDropdown = children.isNotEmpty;
    final isActive = _isActive(activePath, path, aliases);
    final classes = [if (hasDropdown) 'nav-dropdown', if (isActive) 'active'].join(' ');

    return div(classes: classes.isEmpty ? null : classes, [
      Link(
        to: path,
        child: hasDropdown
            ? .fragment([.text(label), span(classes: 'nav-caret', [.text('▾')])])
            : .text(label),
      ),
      if (hasDropdown)
        div(classes: 'nav-dropdown-menu', [
          for (final child in children)
            Link(to: child.path, classes: 'nav-dropdown-link', child: .text(child.label)),
        ]),
    ]);
  }

  // Matches the exact nav path as well as anything nested under it (e.g.
  // `/news/some-post` for `/news`, or `/board` as an alias under `/about`),
  // so detail pages generated per-slug in app.dart still highlight the
  // right top-level nav item.
  static bool _isActive(String activePath, String path, List<String> aliases) {
    bool matches(String candidate) => activePath == candidate || activePath.startsWith('$candidate/');
    return matches(path) || aliases.any(matches);
  }

  @css
  static List<StyleRule> get styles => [
    css('.utility-bar', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 7.px, horizontal: 40.px),
        border: .only(bottom: .solid(color: AppColors.utilityBorder, width: 1.5.px)),
        justifyContent: .spaceBetween,
        alignItems: .center,
        color: AppColors.utilityText,
        fontSize: 12.px,
        backgroundColor: AppColors.lightBlueTint,
      ),
      css('.utility-contact').styles(
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
      ),
      css('.utility-actions', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: .all(12.px),
        ),
        css('.utility-social').styles(
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 14.px,
        ),
        css('.donate-pill').styles(
          padding: .symmetric(vertical: 5.px, horizontal: 14.px),
          radius: .all(.circular(7.px)),
          color: Colors.white,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 14.px,
          fontWeight: .w700,
          backgroundColor: AppColors.accent,
        ),
        css('.donate-pill:focus-visible').styles(
          outline: Outline(color: AppColors.primary, width: OutlineWidth(2.px), style: .solid),
          raw: {'outline-offset': '2px'},
        ),
      ]),
    ]),
    css('header', [
      css('.header-main').styles(
        display: .flex,
        padding: .symmetric(vertical: 14.px, horizontal: 40.px),
        border: .only(bottom: .solid(color: AppColors.borderLight, width: 2.px)),
        justifyContent: .spaceBetween,
        alignItems: .center,
      ),
      css('.brand', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: .all(11.px),
        ),
        css('.brand-mark').styles(
          display: .flex,
          width: 42.px,
          height: 42.px,
          radius: .all(.circular(21.px)),
          justifyContent: .center,
          alignItems: .center,
          color: Colors.white,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 13.px,
          fontWeight: .w700,
          lineHeight: 1.em,
          backgroundColor: AppColors.primary,
        ),
        css('.brand-name').styles(
          color: AppColors.ink,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 18.px,
          fontWeight: .w700,
          lineHeight: 1.em,
        ),
        css('.brand-subtitle').styles(
          margin: .only(top: 2.px),
          color: AppColors.muted,
          fontSize: 11.px,
          fontWeight: .w400,
        ),
      ]),
      css('.brand:focus-visible').styles(
        outline: Outline(color: AppColors.primary, width: OutlineWidth(2.px), style: .solid),
        raw: {'outline-offset': '3px'},
      ),
      css('nav', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: .all(20.px),
        ),
        css('a').styles(
          color: AppColors.ink,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 16.px,
        ),
        css('a:focus-visible').styles(
          radius: .all(.circular(4.px)),
          outline: Outline(color: AppColors.primary, width: OutlineWidth(2.px), style: .solid),
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
          backgroundColor: AppColors.primary,
        ),
        css('.request-info').styles(
          padding: .symmetric(vertical: 8.px, horizontal: 16.px),
          radius: .all(.circular(8.px)),
          color: Colors.white,
          fontWeight: .w700,
          backgroundColor: AppColors.primary,
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
          border: .all(color: AppColors.borderLight, width: 2.px),
          radius: .all(.circular(10.px)),
          shadow: BoxShadow(offsetX: 0.px, offsetY: 8.px, blur: 20.px, color: .rgba(44, 42, 38, 0.14)),
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
          radius: .all(.circular(6.px)),
          color: AppColors.ink,
          fontSize: 14.px,
        ),
        css('.nav-dropdown-link:hover').styles(
          color: AppColors.primary,
          backgroundColor: AppColors.shadedBg,
        ),
      ]),
    ]),
  ];
}
