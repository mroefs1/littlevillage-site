import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  @override
  Component build(BuildContext context) {
    var activePath = context.url;

    return .fragment([
      div(classes: 'utility-bar', [
        div(classes: 'utility-contact', [
          .text('📞 516-520-6000 · ✉ information@littlevillage.org · Seaford, NY'),
        ]),
        div(classes: 'utility-actions', [
          span(classes: 'utility-social', [.text('f ▸ ◎')]),
          a(href: '#', classes: 'donate-pill', [.text('♥ Donate')]),
        ]),
      ]),
      header([
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
        nav([
          for (var route in [
            (label: 'Programs', path: '/programs', aliases: const <String>[]),
            (label: 'Admissions', path: '/admissions', aliases: const <String>[]),
            (label: 'About', path: '/about', aliases: const ['/mission', '/history', '/founders', '/staff', '/board']),
            (label: 'Facilities', path: '/facilities', aliases: const <String>[]),
            (label: 'News & Events', path: '/news', aliases: const ['/events']),
            (label: 'Contact', path: '/contact', aliases: const <String>[]),
          ])
            div(
              classes: _isActive(activePath, route.path, route.aliases) ? 'active' : null,
              [Link(to: route.path, child: .text(route.label))],
            ),
          Link(to: '/contact', classes: 'request-info', child: .text('Request Info')),
        ]),
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
      ]),
    ]),
    css('header', [
      css('&').styles(
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
        css('div.active a').styles(
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
      ]),
    ]),
  ];
}
