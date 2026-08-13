import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';

class TherapeuticServices extends AsyncStatelessComponent {
  const TherapeuticServices({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('therapeutic-services');
    final title = page?.title ?? 'Therapeutic Services';

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
        children: [
          if (page != null) PortableTextView(page.body),
          _closingCta(),
        ],
      ),
    ]);
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
      fontSize: 22.px,
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
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
      raw: {'flex-shrink': '0'},
    ),
  ];
}
