import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../sanity/content_repository.dart';

class OurHistory extends AsyncStatelessComponent {
  const OurHistory({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('history');

    return ContentPage(
      breadcrumb: 'About Us › Our History',
      title: page?.title ?? 'Our History',
      children: [
        if (page != null) PortableTextView(page.body),
      ],
    );
  }
}
