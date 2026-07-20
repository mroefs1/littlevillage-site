import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../sanity/content_repository.dart';

class Founders extends AsyncStatelessComponent {
  const Founders({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('founders');

    return ContentPage(
      breadcrumb: 'About Us › Founders',
      title: page?.title ?? 'Founders',
      children: [
        if (page != null) PortableTextView(page.body),
      ],
    );
  }
}
