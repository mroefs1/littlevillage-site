import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// Fetches the Sanity `page` document (slug "mission") at build time and
// renders its body as portable text. Server-only (never imported by
// main.client.dart / main.client.options.dart, see app.dart), so it's safe
// to do the async Sanity fetch directly in build().
class Mission extends AsyncStatelessComponent {
  const Mission({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('mission');
    final title = page?.title ?? 'Mission Statement';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : "Our mission is to help every child reach their full potential, regardless of their disability.",
        path: '/mission',
      ),
      ContentPage(
        breadcrumb: 'About Us › Mission Statement',
        title: title,
        children: [
          if (page != null) PortableTextView(page.body),
        ],
      ),
    ]);
  }
}
