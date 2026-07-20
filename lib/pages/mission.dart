import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
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

    return ContentPage(
      breadcrumb: 'About Us › Mission Statement',
      title: page?.title ?? 'Mission Statement',
      children: [
        if (page != null) PortableTextView(page.body),
      ],
    );
  }
}
