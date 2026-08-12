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

  const ContentPage({
    required this.breadcrumb,
    required this.title,
    this.children = const [],
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return section(classes: 'page', [
      div(classes: 'page-breadcrumb', [
        Link(to: '/', child: .text('Home')),
        .text(' › $breadcrumb'),
      ]),
      h1([.text(title)]),
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
      css('.page-breadcrumb').styles(
        color: AppColors.mutedTextLight,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 13.px,
      ),
      css('h1').styles(
        margin: .only(top: 6.px),
        fontSize: 38.px,
        fontWeight: .w600,
        letterSpacing: (-0.015).em,
        lineHeight: 1.1.em,
      ),
      css('h2').styles(
        margin: .only(top: 30.px),
        fontSize: 22.px,
        fontWeight: .w600,
        lineHeight: 1.15.em,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('&').styles(
          padding: .only(top: 18.px, left: 20.px, right: 20.px, bottom: 40.px),
        ),
        css('h1').styles(fontSize: 28.px),
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
      css('.detail-meta-text').styles(color: AppColors.navy, fontSize: 15.px),
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
          fontSize: 15.px,
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
        fontSize: 15.px,
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
          fontSize: 17.px,
          fontWeight: .w600,
        ),
        css('.link-card-body').styles(
          margin: .only(top: 6.px),
          color: AppColors.mutedTextLight,
          fontSize: 13.px,
          lineHeight: 1.45.em,
        ),
        css('.link-card-cta').styles(
          margin: .only(top: 10.px),
          color: AppColors.coral,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 14.px,
          fontWeight: .w700,
        ),
      ]),
    ]),
  ];
}
