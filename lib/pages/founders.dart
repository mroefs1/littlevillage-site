import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

class Founders extends AsyncStatelessComponent {
  const Founders({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('founders');
    final title = page?.title ?? 'Founders';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'The founders of Hagedorn Little Village School and the Jack Joel Center for Special Children.',
        path: '/founders',
      ),
      ContentPage(
        breadcrumb: 'About Us › Founders',
        title: title,
        children: [
          if (page != null) PortableTextView(page.body),
        ],
      ),
    ]);
  }
}
