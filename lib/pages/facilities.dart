import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

class Facilities extends AsyncStatelessComponent {
  const Facilities({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('facilities');
    final title = page?.title ?? 'School Facilities';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'A look at the facilities at Hagedorn Little Village School on Long Island.',
        path: '/facilities',
      ),
      ContentPage(
        breadcrumb: 'School Facilities',
        title: title,
        children: [
          if (page != null) PortableTextView(page.body),
        ],
      ),
    ]);
  }
}
