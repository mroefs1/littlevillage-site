import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../sanity/content_repository.dart';

class Contact extends AsyncStatelessComponent {
  const Contact({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('contact');

    return ContentPage(
      breadcrumb: 'Contact',
      title: page?.title ?? 'Contact Us',
      children: [
        if (page != null) PortableTextView(page.body),
      ],
    );
  }
}
