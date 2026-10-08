import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

class Compliance extends AsyncStatelessComponent {
  const Compliance({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('compliance');
    final title = page?.title ?? 'Compliance';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : "Hagedorn Little Village School's compliance plan, Dignity Act coordinator, and reporting process.",
        path: '/compliance',
      ),
      ContentPage(
        breadcrumb: 'About Us › Compliance',
        title: title,
        heroImage: page?.heroImage,
        gallery: page?.images ?? const [],
        // Same case as Data Privacy and Security: ~2,600 characters of body
        // ran the full 1088px container at ~127 characters a line. The other
        // pages on this container carry a few hundred characters, where that
        // measure costs little.
        insetPercent: 15,
        children: [
          if (page != null) PortableTextView(page.body),
        ],
      ),
    ]);
  }
}
