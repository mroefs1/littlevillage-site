import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

// Shared layout for simple informational pages (About, Mission, History,
// Founders, Facilities, Contact): a breadcrumb + H1 + optional lede, followed
// by page-specific content. Also defines a small set of reusable content
// blocks (`.info-card`, `.callout`, `.person-card`, `.link-card`) so these
// pages share one visual language instead of each inventing its own.
class ContentPage extends StatelessComponent {
  final String breadcrumb;
  final String title;
  final String? lede;
  final List<Component> children;

  const ContentPage({
    required this.breadcrumb,
    required this.title,
    this.lede,
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
      if (lede != null) p(classes: 'page-lede', [.text(lede!)]),
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
        color: AppColors.muted,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 12.px,
      ),
      css('h1').styles(
        margin: .only(top: 6.px),
        fontSize: 36.px,
        lineHeight: 1.05.em,
      ),
      css('.page-lede').styles(
        maxWidth: 620.px,
        margin: .only(top: 10.px),
        color: AppColors.body,
        fontSize: 15.px,
        lineHeight: 1.55.em,
      ),
      // Bordered content block with a tinted header — for grouped info.
      css('.info-card', [
        css('&').styles(
          margin: .only(top: 22.px),
          border: .all(color: AppColors.borderMedium, width: 2.px),
          radius: .all(.circular(10.px)),
          overflow: .clip,
        ),
        css('.info-card-header').styles(
          padding: .symmetric(vertical: 14.px, horizontal: 20.px),
          color: AppColors.ink,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 19.px,
          fontWeight: .w700,
          backgroundColor: AppColors.lightBlueTint,
        ),
        css('.info-card-body', [
          css('&').styles(
            padding: .all(20.px),
            color: AppColors.body,
            fontSize: 14.px,
            lineHeight: 1.55.em,
          ),
          css('p').styles(
            margin: .only(top: 10.px),
          ),
          css('p:first-child').styles(
            margin: .zero,
          ),
          css('ul').styles(
            padding: .only(left: 20.px),
            margin: .zero,
          ),
          css('li').styles(
            margin: .only(top: 6.px),
          ),
        ]),
      ]),
      // Highlighted stat/figure callout — e.g. "$0", "77,000 sq ft".
      css('.callout', [
        css('&').styles(
          display: .flex,
          padding: .symmetric(vertical: 20.px, horizontal: 24.px),
          margin: .only(top: 24.px),
          border: .all(color: Color('#cdd9ee'), width: 2.px),
          radius: .all(.circular(10.px)),
          alignItems: .center,
          gap: .all(18.px),
          backgroundColor: AppColors.lightBlueTint,
        ),
        css('.callout-figure').styles(
          color: AppColors.primary,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 40.px,
          fontWeight: .w700,
        ),
        css('.callout-title').styles(
          color: AppColors.ink,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 19.px,
          fontWeight: .w700,
        ),
        css('.callout-body').styles(
          margin: .only(top: 3.px),
          color: AppColors.body,
          fontSize: 13.px,
          lineHeight: 1.45.em,
        ),
      ]),
      // Grid of people (founders, staff) with a circular initials avatar.
      css('.person-grid').styles(
        display: .flex,
        margin: .only(top: 22.px),
        flexWrap: .wrap,
        gap: .all(20.px),
      ),
      css('.person-card', [
        css('&').styles(
          minWidth: 260.px,
          padding: .all(20.px),
          border: .all(color: AppColors.borderLight, width: 2.px),
          radius: .all(.circular(10.px)),
          flex: Flex(grow: 1, basis: 260.px),
        ),
        css('.person-avatar').styles(
          display: .flex,
          width: 56.px,
          height: 56.px,
          radius: .all(.circular(28.px)),
          justifyContent: .center,
          alignItems: .center,
          color: Colors.white,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 18.px,
          fontWeight: .w700,
          backgroundColor: AppColors.primary,
        ),
        css('.person-name').styles(
          margin: .only(top: 12.px),
          color: AppColors.ink,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 18.px,
          fontWeight: .w700,
        ),
        css('.person-credentials').styles(
          margin: .only(top: 2.px),
          color: AppColors.muted,
          fontSize: 12.px,
        ),
        css('.person-bio').styles(
          margin: .only(top: 10.px),
          color: AppColors.body,
          fontSize: 13.px,
          lineHeight: 1.5.em,
        ),
      ]),
      // Grid of link-out cards — e.g. the About hub's quick links.
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
          border: .all(color: AppColors.borderMedium, width: 2.px),
          radius: .all(.circular(10.px)),
          flex: Flex(grow: 1, basis: 220.px),
        ),
        css('.link-card-title').styles(
          color: AppColors.primary,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 18.px,
          fontWeight: .w700,
        ),
        css('.link-card-body').styles(
          margin: .only(top: 6.px),
          color: AppColors.body,
          fontSize: 13.px,
          lineHeight: 1.45.em,
        ),
        css('.link-card-cta').styles(
          margin: .only(top: 10.px),
          color: AppColors.primary,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 14.px,
          fontWeight: .w700,
        ),
      ]),
    ]),
  ];
}
