import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

// Shared layout for simple informational pages (About, Mission, History,
// Founders, Facilities, Contact): a breadcrumb + H1, followed by
// page-specific content — typically a `PortableTextView` of the page's
// Sanity body. Also defines the `.link-card` grid used by the About hub.
class ContentPage extends StatelessComponent {
  final String breadcrumb;
  final String title;
  final List<Component> children;
  // Horizontal inset applied to both the H1 and `children`, so the title's
  // left edge lines up with the body content instead of the breadcrumb's
  // (the breadcrumb always stays at `.page`'s own left edge regardless).
  // Sitewide default; pass 0 to opt out (Current Families, for its
  // full-width calendar embed) or a different value to override the inset
  // amount (Data Privacy and Security uses 15, since its body runs
  // unusually long and includes a full-width video embed).
  final double insetPercent;

  const ContentPage({
    required this.breadcrumb,
    required this.title,
    this.children = const [],
    this.insetPercent = 10,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final inset = insetPercent > 0;
    // The inset percentage rides on a custom property rather than being an
    // inline `padding`, and the padding itself is applied by the
    // `.page-inset` rule below. Inline padding beat every stylesheet rule,
    // so a page could not narrow its own inset at a breakpoint without
    // `!important` - which is what the Contact page needs at mobile, where
    // 10% each side leaves less room than the Turnstile widget's fixed
    // 300px minimum. The class is also a stable hook for that override.
    // Declared once on the section, not on each inset child: the h1 and the
    // body wrapper only *read* the variable, so a page can retune its inset
    // at a breakpoint by overriding this one declaration and both move
    // together, keeping the title/body alignment Step 14 established.
    final insetStyles = inset ? Styles(raw: {'--page-inset': '$insetPercent%'}) : null;
    return section(classes: 'page', styles: insetStyles, [
      div(classes: 'page-breadcrumb', [
        Link(to: '/', child: .text('Home')),
        .text(' › $breadcrumb'),
      ]),
      h1(classes: inset ? 'page-inset' : null, [.text(title)]),
      if (inset)
        div(classes: 'page-inset', children)
      else
        ...children,
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.page', [
      css('&').styles(
        display: .flex,
        padding: .only(top: 22.px, left: 40.px, right: 40.px, bottom: 60.px),
        flexDirection: .column,
      ),
      // Reads an override variable first, falling back to the page's own
      // inset. `--page-inset` is set inline by the component, and an inline
      // custom property beats any stylesheet rule - so a page that needs to
      // retune its inset at a breakpoint sets `--page-inset-override`
      // instead, which nothing declares inline and which therefore cascades
      // normally. This keeps the escape hatch free of `!important`.
      css('.page-inset').styles(
        raw: {
          'padding-left': 'var(--page-inset-override, var(--page-inset))',
          'padding-right': 'var(--page-inset-override, var(--page-inset))',
        },
      ),
      css('.page-breadcrumb').styles(
        color: AppColors.mutedTextLight,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 0.8125.rem,
      ),
      css('h1').styles(
        margin: .only(top: 6.px),
        fontSize: 2.375.rem,
        fontWeight: .w600,
        letterSpacing: (-0.015).em,
        lineHeight: 1.1.em,
      ),
      css('h2').styles(
        margin: .only(top: 30.px),
        fontSize: 1.375.rem,
        fontWeight: .w600,
        lineHeight: 1.15.em,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('&').styles(
          padding: .only(top: 18.px, left: 20.px, right: 20.px, bottom: 40.px),
        ),
        css('h1').styles(fontSize: 1.75.rem),
      ]),
      // News/event detail pages: a centered column with a meta bar, hero
      // image (auto height so it scales without cropping regardless of the
      // source image's dimensions), body paragraphs, and an optional CTA
      // link (ticket/RSVP for events, "read more" for news).
      css('.detail-container').styles(maxWidth: 760.px, raw: {'margin-left': 'auto', 'margin-right': 'auto'}),
      css('.detail-meta-bar').styles(
        display: .flex,
        margin: .only(top: 10.px),
        flexWrap: .wrap,
        gap: .all(20.px),
      ),
      css('.detail-meta-item').styles(display: .flex, alignItems: .center, gap: .all(6.px)),
      css('.detail-meta-icon').styles(color: AppColors.mutedTextLight),
      css('.detail-meta-text').styles(color: AppColors.navy, fontSize: 0.9375.rem),
      css('.detail-hero').styles(margin: .only(top: 18.px)),
      css('.detail-hero-image').styles(
        display: .block,
        width: 100.percent,
        height: .auto,
        radius: .all(.circular(Radii.lg)),
      ),
      css('.detail-body', [
        css('&').styles(
          margin: .only(top: 18.px),
          color: AppColors.mutedText,
          fontSize: 0.9375.rem,
          lineHeight: 1.55.em,
        ),
        css('p').styles(margin: .only(top: 10.px)),
        css('p:first-child').styles(margin: .zero),
      ]),
      // Newsletter/"read more"/RSVP teaser — light sky box, matching the
      // same "info teaser" pattern used elsewhere (e.g. program detail's
      // how-to-start band), not a bordered/tinted box.
      css('.detail-cta').styles(
        padding: .all(24.px),
        margin: .only(top: 16.px),
        radius: .all(.circular(Radii.xxl)),
        textAlign: .center,
        backgroundColor: AppColors.sky,
      ),
      css('.detail-cta-btn').styles(
        display: .inlineBlock,
        padding: .symmetric(vertical: 12.px, horizontal: 24.px),
        radius: .all(.circular(Radii.pill)),
        color: Colors.white,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 0.9375.rem,
        fontWeight: .w700,
        backgroundColor: AppColors.coral,
      ),
      // Grid of link-out cards — newsletters on the News & Events page.
      css('.link-grid').styles(
        display: .flex,
        margin: .only(top: 26.px),
        flexWrap: .wrap,
        gap: .all(16.px),
      ),
      css('.link-card', [
        css('&').styles(
          minWidth: 220.px,
          padding: .all(18.px),
          border: .all(color: AppColors.line, width: 1.px),
          radius: .all(.circular(Radii.lg)),
          flex: Flex(grow: 1, basis: 220.px),
          backgroundColor: Colors.white,
        ),
        css('.link-card-title').styles(
          color: AppColors.navy,
          fontFamily: .list([headingFontFamily, FontFamilies.serif]),
          fontSize: 1.0625.rem,
          fontWeight: .w600,
        ),
        css('.link-card-body').styles(
          margin: .only(top: 6.px),
          color: AppColors.mutedTextLight,
          fontSize: 0.8125.rem,
          lineHeight: 1.45.em,
        ),
        css('.link-card-cta').styles(
          margin: .only(top: 10.px),
          color: AppColors.coral,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.875.rem,
          fontWeight: .w700,
        ),
      ]),
    ]),
  ];
}
