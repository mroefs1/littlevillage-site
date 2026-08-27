import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../sanity/models/site_settings.dart';

// Brand glyphs for the social links in the utility bar. Single-path,
// 24x24-viewBox marks from Simple Icons (CC0), inlined as Dart string
// constants rather than fetched or shipped as asset files: they're two lines
// of markup each, they inherit `currentColor` so the bar's white text color
// styles them for free, and inlining keeps the strict no-external-requests
// posture the rest of the site already has.
//
// Keyed by the `platform` values the `siteSettings.socialLinks` schema
// offers. The two it offers that we have no mark for (Twitter / X, LinkedIn)
// fall back to a plain text label in the header, so an editor adding one
// still gets a working link rather than an invisible one.
const _iconPaths = <String, String>{
  'Facebook':
      'M9.101 23.691v-7.98H6.627v-3.667h2.474v-1.58c0-4.085 1.848-5.978 5.858-5.978.401 0 .955.042 1.468.103a8.68 8.68 0 0 1 1.141.195v3.325a8.623 8.623 0 0 0-.653-.036 26.805 26.805 0 0 0-.733-.009c-.707 0-1.259.096-1.675.309a1.686 1.686 0 0 0-.679.622c-.258.42-.374.995-.374 1.752v1.297h3.919l-.386 2.103-.287 1.564h-3.246v8.245C19.396 23.238 24 18.179 24 12.044c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.628 3.874 10.35 9.101 11.647Z',
  'Instagram':
      'M7.0301.084c-1.2768.0602-2.1487.264-2.911.5634-.7888.3075-1.4575.72-2.1228 1.3877-.6652.6677-1.075 1.3368-1.3802 2.127-.2954.7638-.4956 1.6365-.552 2.914-.0564 1.2775-.0689 1.6882-.0626 4.947.0062 3.2586.0206 3.6671.0825 4.9473.061 1.2765.264 2.1482.5635 2.9107.308.7889.72 1.4573 1.388 2.1228.6679.6655 1.3365 1.0743 2.1285 1.38.7632.295 1.6361.4961 2.9134.552 1.2773.056 1.6884.069 4.9462.0627 3.2578-.0062 3.668-.0207 4.9478-.0814 1.28-.0607 2.147-.2652 2.9098-.5633.7889-.3086 1.4578-.72 2.1228-1.3881.665-.6682 1.0745-1.3378 1.3795-2.1284.2957-.7632.4966-1.636.552-2.9124.056-1.2809.0692-1.6898.063-4.948-.0063-3.2583-.021-3.6668-.0817-4.9465-.0607-1.2797-.264-2.1487-.5633-2.9117-.3084-.7889-.72-1.4568-1.3876-2.1228C21.2982 1.33 20.628.9208 19.8378.6165 19.074.321 18.2017.1197 16.9244.0645 15.6471.0093 15.236-.005 11.977.0014 8.718.0076 8.31.0215 7.0301.0839m.1402 21.6932c-1.17-.0509-1.8053-.2453-2.2287-.408-.5606-.216-.96-.4771-1.3819-.895-.422-.4178-.6811-.8186-.9-1.378-.1644-.4234-.3624-1.058-.4171-2.228-.0595-1.2645-.072-1.6442-.079-4.848-.007-3.2037.0053-3.583.0607-4.848.05-1.169.2456-1.805.408-2.2282.216-.5613.4762-.96.895-1.3816.4188-.4217.8184-.6814 1.3783-.9003.423-.1651 1.0575-.3614 2.227-.4171 1.2655-.06 1.6447-.072 4.848-.079 3.2033-.007 3.5835.005 4.8495.0608 1.169.0508 1.8053.2445 2.228.408.5608.216.96.4754 1.3816.895.4217.4194.6816.8176.9005 1.3787.1653.4217.3617 1.056.4169 2.2263.0602 1.2655.0739 1.645.0796 4.848.0058 3.203-.0055 3.5834-.061 4.848-.051 1.17-.245 1.8055-.408 2.2294-.216.5604-.4763.96-.8954 1.3814-.419.4215-.8181.6811-1.3783.9-.4224.1649-1.0577.3617-2.2262.4174-1.2656.0595-1.6448.072-4.8493.079-3.2045.007-3.5825-.006-4.848-.0608M16.953 5.5864A1.44 1.44 0 1 0 18.39 4.144a1.44 1.44 0 0 0-1.437 1.4424M5.8385 12.012c.0067 3.4032 2.7706 6.1557 6.173 6.1493 3.4026-.0065 6.157-2.7701 6.1506-6.1733-.0065-3.4032-2.771-6.1565-6.174-6.1498-3.403.0067-6.156 2.771-6.1496 6.1738M8 12.0077a4 4 0 1 1 4.008 3.9921A3.9996 3.9996 0 0 1 8 12.0077',
  'YouTube':
      'M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z',
};

/// The SVG path data for [platform]'s brand mark, or null when we have no
/// mark for it.
String? socialIconPath(String platform) => _iconPaths[platform];

/// The brand mark for [platform], sized by CSS (`.social-icon`) and painted
/// in the surrounding text color. Decorative: the link that wraps it carries
/// the accessible name.
Component socialIcon(String iconPath) {
  return svg(
    viewBox: '0 0 24 24',
    classes: 'social-icon',
    attributes: const {'fill': 'currentColor', 'aria-hidden': 'true', 'focusable': 'false'},
    [path(d: iconPath, [])],
  );
}

/// A row of links to the school's social profiles, from `siteSettings` — the
/// utility bar uses it, and so does the footer, which is where they stay
/// reachable at the phone widths the bar has no room for them at.
///
/// [wrapperClass] scopes the row's own layout (spacing, when it hides) to the
/// place it's used; the link and icon styling below is shared by both.
class SocialLinks extends StatelessComponent {
  final List<SocialLink> links;
  final String wrapperClass;

  const SocialLinks(this.links, {required this.wrapperClass, super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: wrapperClass, [
      for (final social in links) _link(social),
    ]);
  }

  // The brand mark carries no text, so the accessible name lives on the link
  // itself. A platform we have no mark for (the schema also offers Twitter / X
  // and LinkedIn) falls back to its name as visible text rather than
  // rendering an empty link.
  static Component _link(SocialLink social) {
    final iconPath = socialIconPath(social.platform);
    return a(
      href: social.url,
      target: Target.blank,
      classes: iconPath != null ? 'social-link' : 'social-link social-link-text',
      attributes: {'aria-label': social.platform},
      [if (iconPath != null) socialIcon(iconPath) else .text(social.platform)],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // 28px square: comfortably over WCAG 2.2 SC 2.5.8's 24px minimum target,
    // and still inside the 31px the donate pill already sets as the utility
    // bar's height, so giving the icons a real tap target doesn't make that
    // bar taller.
    css('.social-link').styles(
      display: .flex,
      width: 28.px,
      height: 28.px,
      radius: .all(.circular(Radii.pill)),
      justifyContent: .center,
      alignItems: .center,
      color: Colors.white,
    ),
    // A platform with no brand mark renders its name instead, so it needs
    // room for the text rather than a fixed square.
    css('.social-link-text').styles(
      width: .auto,
      padding: .symmetric(horizontal: 8.px),
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 0.8125.rem,
    ),
    css('.social-icon').styles(display: .block, width: 18.px, height: 18.px),
    // The mark is already white on both surfaces this appears on, so the
    // hover state is a translucent white disc behind it rather than a new
    // color.
    css('.social-link:hover').styles(backgroundColor: const Color('#ffffff29')),
    // White outline, not the sitewide blue — against navy, blue only clears
    // ~2:1, under the 3:1 floor for a visible focus indicator (the same
    // reasoning the donate pill and the footer links already use).
    css('.social-link:focus-visible').styles(
      outline: Outline(color: Colors.white, width: OutlineWidth(2.px), style: .solid),
      raw: {'outline-offset': '2px'},
    ),
  ];
}
