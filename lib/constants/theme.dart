import 'package:jaspr/dom.dart';

// Design tokens from the homepage/admissions design handoff
// (design_handoff_homepage_admissions/). Placeholder values —
// not yet a confirmed final brand palette per that handoff's README.
class AppColors {
  static const primary = Color('#2f5aa8');
  // Darkened from the original handoff value (#d97a2b) — at full brightness
  // white text on this background failed WCAG AA (3.1:1) for the donate
  // pill/button; this shade clears 4.5:1.
  static const accent = Color('#a35c20');
  static const ink = Color('#2c2a26');
  static const body = Color('#6b6760');
  // Darkened from the original handoff value (#8a8578) — at full brightness
  // this failed WCAG AA (3.68:1) as small text on white; this shade clears
  // 4.5:1.
  static const muted = Color('#757166');

  static const lightBlueTint = Color('#eef2f8');
  static const utilityBorder = Color('#dfe5ef');
  static const utilityText = Color('#5a6a86');

  static const borderLight = Color('#ece9e1');
  static const borderMedium = Color('#c9c4b8');

  static const pillTint = Color('#e4ebf6');
  static const shadedBg = Color('#f5f3ee');
  static const placeholderBorder = Color('#bdb8ab');
  static const placeholderStripe = Color('#e3dfd5');

  static const warmTint = Color('#f6e7d6');
  static const warmBorder = Color('#e7c79f');
  static const warmText = Color('#8a4f17');
  static const warmMutedText = Color('#805429');

  static const footerNavy = Color('#2b3550');
  static const footerLink = Color('#9fb0cc');
  static const footerMuted = Color('#cdd6e6');
}

const headingFontFamily = FontFamily('Gaegu');
const bodyFontFamily = FontFamily('system-ui');

@css
List<StyleRule> get globalStyles => [
  css.import('https://fonts.googleapis.com/css2?family=Gaegu:wght@400;700&display=swap'),
  css('html, body').styles(
    width: 100.percent,
    minHeight: 100.vh,
    padding: .zero,
    margin: .zero,
    color: AppColors.ink,
    fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
  ),
  css('h1, h2, h3').styles(
    margin: .unset,
    fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
    fontWeight: .w700,
  ),
  css('a').styles(
    color: .inherit,
    textDecoration: TextDecoration(line: .none),
  ),
  // Sitewide default focus indicator so every interactive element has a
  // visible, high-contrast state even before a component defines its own
  // (header/footer override this locally where the default primary-blue
  // ring wouldn't have enough contrast against their backgrounds).
  css('a:focus-visible, button:focus-visible').styles(
    radius: .all(.circular(4.px)),
    outline: Outline(color: AppColors.primary, width: OutlineWidth(2.px), style: .solid),
    raw: {'outline-offset': '2px'},
  ),
];
