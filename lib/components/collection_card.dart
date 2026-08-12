import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

// Shared card for grids of collection items — news posts, events, staff and
// board members. Renders an optional image, a small eyebrow line (date,
// location, or job title), a title, an optional excerpt, and links either
// internally (`linkTo`, a detail page) or externally (`externalHref`, e.g. a
// news post's original link when it predates the `slug` field). Used by
// news_events.dart, staff.dart, and board.dart to avoid four near-identical
// card layouts.
class CollectionCard extends StatelessComponent {
  final String? imageUrl;
  final String imageAlt;
  final String? eyebrow;
  final String title;
  final String? excerpt;
  final String? linkTo;
  final String? externalHref;
  final String linkLabel;

  const CollectionCard({
    required this.title,
    this.imageUrl,
    this.imageAlt = 'Photo',
    this.eyebrow,
    this.excerpt,
    this.linkTo,
    this.externalHref,
    this.linkLabel = 'Learn more →',
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final content = [
      if (imageUrl != null) img(src: imageUrl!, alt: imageAlt, classes: 'collection-card-image'),
      div(classes: 'collection-card-body', [
        if (eyebrow != null) div(classes: 'collection-card-eyebrow', [.text(eyebrow!)]),
        div(classes: 'collection-card-title', [.text(title)]),
        if (excerpt != null) div(classes: 'collection-card-excerpt', [.text(excerpt!)]),
        if (linkTo != null || externalHref != null) div(classes: 'collection-card-cta', [.text(linkLabel)]),
      ]),
    ];

    if (linkTo != null) {
      return Link(to: linkTo!, classes: 'collection-card', child: .fragment(content));
    }
    if (externalHref != null) {
      return a(href: externalHref!, target: Target.blank, classes: 'collection-card', content);
    }
    return div(classes: 'collection-card', content);
  }

  @css
  static List<StyleRule> get styles => [
    css('.card-grid').styles(
      display: .flex,
      margin: .only(top: 18.px),
      flexWrap: .wrap,
      gap: .all(18.px),
    ),
    css('.collection-card', [
      css('&').styles(
        display: .flex,
        maxWidth: 320.px,
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.lg)),
        overflow: .hidden,
        flexDirection: .column,
        flex: Flex(grow: 1, basis: 260.px),
        backgroundColor: Colors.white,
      ),
      css('.collection-card-image').styles(
        width: 100.percent,
      ),
      css('.collection-card-body').styles(
        display: .flex,
        padding: .all(16.px),
        flexDirection: .column,
        flex: Flex(grow: 1),
      ),
      css('.collection-card-eyebrow').styles(
        color: AppColors.mutedTextLight,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 12.px,
        fontWeight: .w700,
        textTransform: .upperCase,
        letterSpacing: 0.06.em,
      ),
      css('.collection-card-title').styles(
        margin: .only(top: 6.px),
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 18.px,
        fontWeight: .w600,
      ),
      css('.collection-card-excerpt').styles(
        margin: .only(top: 8.px),
        flex: Flex(grow: 1),
        color: AppColors.mutedTextMid,
        fontSize: 13.px,
        lineHeight: 1.45.em,
      ),
      css('.collection-card-cta').styles(
        margin: .only(top: 12.px),
        color: AppColors.coral,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 14.px,
        fontWeight: .w700,
      ),
    ]),
  ];
}
