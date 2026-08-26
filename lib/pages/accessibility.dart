import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// Sanity-backed like Compliance and Data Privacy, deliberately: an
// accessibility statement is only useful while it is accurate, and it names
// specific known limitations that will change as they are fixed. Keeping it
// editable means it can be corrected without a deploy.
class Accessibility extends AsyncStatelessComponent {
  const Accessibility({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('accessibility');
    final title = page?.title ?? 'Accessibility';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'How this site is built for accessibility, what we know falls short, and how to tell us about a problem.',
        path: '/accessibility',
      ),
      ContentPage(
        breadcrumb: 'About Us › Accessibility',
        title: title,
        children: [
          if (page != null) PortableTextView(page.body),
        ],
      ),
    ]);
  }
}
