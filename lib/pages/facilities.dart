import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../sanity/content_repository.dart';

class Facilities extends AsyncStatelessComponent {
  const Facilities({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('facilities');

    return ContentPage(
      breadcrumb: 'School Facilities',
      title: page?.title ?? 'School Facilities',
      children: [
        if (page != null) PortableTextView(page.body),
      ],
    );
  }
}
