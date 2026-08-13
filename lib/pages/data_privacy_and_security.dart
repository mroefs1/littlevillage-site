import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

class DataPrivacyAndSecurity extends AsyncStatelessComponent {
  const DataPrivacyAndSecurity({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('data-privacy-and-security');
    final title = page?.title ?? 'Data Privacy and Security';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : "How Hagedorn Little Village School protects student, teacher, and principal data under NYS Education Law 2-d and FERPA.",
        path: '/data-privacy-and-security',
      ),
      ContentPage(
        breadcrumb: 'About Us › Data Privacy and Security',
        title: title,
        children: [
          // This page's body runs unusually long and includes a full-width
          // video embed, so it gets its own inset column rather than using
          // `.page`'s full width like the shorter About sub-pages do — the
          // video shrinks along with it since `.video-embed-frame` is 100%
          // of its container.
          if (page != null) div(classes: 'dps-body', [PortableTextView(page.body)]),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.dps-body').styles(padding: .symmetric(horizontal: 15.percent)),
  ];
}
