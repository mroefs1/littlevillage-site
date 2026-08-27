import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';
import '../sanity/models/site_settings.dart';
import 'social_icons.dart';

class Footer extends StatelessComponent {
  /// Same `siteSettings` list the header's utility bar renders. Repeated here
  /// deliberately: the bar has no room for them below 480px, and the footer is
  /// where a visitor on a phone expects to find them anyway.
  final List<SocialLink> socialLinks;

  const Footer({this.socialLinks = const [], super.key});

  @override
  Component build(BuildContext context) {
    return footer([
      div(classes: 'footer-about', [
        // Proper noun, exempted from machine translation for the same
        // reason as the header's copy of the name (see `header.dart`).
        div(
          classes: 'footer-school-name notranslate',
          attributes: const {'translate': 'no'},
          [.text('The Hagedorn Little Village School')],
        ),
        div(classes: 'footer-address', [
          .text('Seaford, NY · 516-520-6000'),
          br(),
          .text('A publicly funded, not-for-profit school.'),
        ]),
        if (socialLinks.isNotEmpty) SocialLinks(socialLinks, wrapperClass: 'footer-social'),
      ]),
      div(classes: 'footer-columns', [
        _footerColumn('Programs', const [
          (label: 'Early Intervention', path: '/programs'),
          (label: 'Preschool', path: '/programs'),
          (label: 'Elementary', path: '/programs'),
        ]),
        _footerColumn('Get started', const [
          (label: 'Admissions', path: '/admissions'),
          (label: 'Request info', path: '/contact'),
          (label: 'Schedule a tour', path: '/contact'),
        ]),
        _footerColumn('Community', const [
          (label: 'News & events', path: '/news'),
          (label: 'Current families', path: '/current-families'),
          (label: 'Donate', path: '/support-us'),
          (label: 'Careers', path: '/careers'),
          (label: 'Accessibility', path: '/accessibility'),
          (label: 'Parent portal', path: '#'),
        ]),
      ]),
    ]);
  }

  static Component _footerColumn(String title, List<({String label, String path})> links) {
    return div(classes: 'footer-column', [
      span(classes: 'footer-column-title', [.text(title)]),
      for (final link in links) Link(to: link.path, child: .text(link.label)),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('footer', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 24.px, horizontal: 40.px),
        justifyContent: .spaceBetween,
        gap: .all(20.px),
        backgroundColor: AppColors.navyDarker,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('&').styles(
          padding: .symmetric(vertical: 24.px, horizontal: 20.px),
          flexDirection: .column,
          gap: .all(22.px),
        ),
      ]),
      css('.footer-about', [
        css('&').styles(
          maxWidth: 240.px,
          color: AppColors.footerMuted,
          fontSize: 0.75.rem,
        ),
        css('.footer-school-name').styles(
          color: Colors.white,
          fontFamily: .list([headingFontFamily, FontFamilies.serif]),
          fontSize: 1.rem,
          fontWeight: .w700,
        ),
        css('.footer-address').styles(
          margin: .only(top: 6.px),
          lineHeight: 1.5.em,
        ),
        // Sits left-aligned with the address above it, pulled out by the
        // link's own 28px box so the row of marks lines up with the text
        // rather than the box's padding.
        css('.footer-social').styles(
          display: .flex,
          margin: .only(top: 10.px, left: (-5).px),
          gap: .all(2.px),
        ),
      ]),
      css('.footer-columns').styles(
        display: .flex,
        gap: .all(34.px),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('.footer-about').styles(maxWidth: 100.percent),
        css('.footer-columns').styles(flexWrap: .wrap, gap: .all(24.px)),
      ]),
      css('.footer-column', [
        css('&').styles(
          display: .flex,
          flexDirection: .column,
          gap: .all(2.px),
          color: AppColors.footerLink,
          fontSize: 0.8125.rem,
        ),
        // WCAG 2.2 SC 2.5.8 (Target Size, Minimum) asks for interactive
        // targets of at least 24x24 CSS px. These links rendered 17px tall,
        // which was the entirety of the site's own target-size finding -
        // 707 instances in an axe sweep, all of them this one rule repeated
        // through the footer on all 32 pages. A min-height floor with the
        // text centred, rather than a fixed line-height, holds the 24px
        // minimum at the default size while still growing with the visitor's
        // own text size - a px line-height would have clipped descenders
        // once the text scaled past it. It also makes the whole row
        // clickable rather than just the glyphs.
        css('a').styles(
          display: .flex,
          minHeight: 24.px,
          alignItems: .center,
        ),
        css('.footer-column-title').styles(
          margin: .only(bottom: 10.px),
          color: AppColors.yellow,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.75.rem,
          fontWeight: .w700,
          textTransform: .upperCase,
          letterSpacing: 0.1.em,
        ),
      ]),
      // White outline, not the sitewide primary blue — on this dark navy
      // background primary only clears ~1.8:1 contrast, well under the 3:1
      // WCAG floor for a visible focus indicator.
      css('a:focus-visible').styles(
        radius: .all(.circular(4.px)),
        outline: Outline(color: Colors.white, width: OutlineWidth(2.px), style: .solid),
        raw: {'outline-offset': '2px'},
      ),
    ]),
  ];
}
