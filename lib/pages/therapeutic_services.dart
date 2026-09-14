import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../constants/therapeutic_sections.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/portable_text.dart';

class TherapeuticServices extends AsyncStatelessComponent {
  const TherapeuticServices({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('therapeutic-services');
    final title = page?.title ?? 'Therapeutic Services';
    if (page != null) _warnMissingSections(page.body);

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'Speech-language, occupational, physical, and psychological therapy services at Hagedorn Little Village School.',
        path: '/programs/therapeutic-services',
      ),
      ContentPage(
        breadcrumb: 'Programs › Therapeutic Services',
        title: title,
        heroImage: page?.heroImage,
        gallery: page?.images ?? const [],
        children: [
          if (page != null) PortableTextView(page.body),
          _closingCta(),
        ],
      ),
    ]);
  }

  // The program pages' "Services included" pills deep link into this page's
  // section cards, whose ids come from the section titles. Renaming a section
  // in Sanity therefore drops its anchor and those links quietly land at the
  // top of the page instead. This is the only place that holds both halves —
  // the anchor list and the real content — and it renders on every static
  // build, so the mismatch shows up in the build log rather than in a
  // visitor's browser.
  static void _warnMissingSections(PortableText body) {
    final titles = body.blocks
        .where((block) => block['_type'] == 'serviceSection')
        .map((block) => block['title'] as String? ?? '')
        .toSet();
    final missing = TherapeuticSections.all.where((known) => !titles.contains(known.title)).toList();
    if (missing.isEmpty) return;
    print(
      'WARNING: /programs/therapeutic-services has no serviceSection titled '
      '${missing.map((entry) => '"${entry.title}"').join(', ')} — deep links to '
      '${missing.map((entry) => '#${entry.anchor}').join(', ')} will land at the top of '
      'the page. Update lib/constants/therapeutic_sections.dart if the section '
      'was renamed in Sanity.',
    );
  }

  static Component _closingCta() {
    return div(classes: 'ts-cta', [
      div([
        div(classes: 'ts-cta-title', [.text('Have questions about therapeutic services?')]),
        div(classes: 'ts-cta-subtitle', [.text('Our team is happy to talk through what your child may need.')]),
      ]),
      Link(to: '/contact', classes: 'ts-cta-btn', child: .text('Contact us →')),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.ts-cta').styles(
      display: .flex,
      padding: .all(40.px),
      margin: .only(top: 20.px),
      radius: .all(.circular(Radii.xxl)),
      flexWrap: .wrap,
      justifyContent: .spaceBetween,
      alignItems: .center,
      gap: .all(24.px),
      backgroundColor: AppColors.navyDark,
    ),
    css('.ts-cta-title').styles(
      color: Colors.white,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 1.375.rem,
      fontWeight: .w600,
    ),
    css('.ts-cta-subtitle').styles(
      margin: .only(top: 6.px),
      color: AppColors.footerMuted,
    ),
    css('.ts-cta-btn').styles(
      display: .inlineBlock,
      padding: .symmetric(vertical: 14.px, horizontal: 28.px),
      radius: .all(.circular(Radii.pill)),
      color: Colors.white,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 0.9375.rem,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
      raw: {'flex-shrink': '0'},
    ),
  ];
}
