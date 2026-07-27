import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

class OurHistory extends AsyncStatelessComponent {
  const OurHistory({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('history');
    final title = page?.title ?? 'Our History';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'The history of Hagedorn Little Village School, part of the Jack Joel Center for Special Children.',
        path: '/history',
      ),
      ContentPage(
        breadcrumb: 'About Us › Our History',
        title: title,
        children: [
          if (page != null) PortableTextView(page.body),
        ],
      ),
    ]);
  }
}
