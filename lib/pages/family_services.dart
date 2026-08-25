import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// The Family Services page (Step 19) — a standalone `page` document like
// Therapeutic Services and CPSE Evaluations, not a `program` (that type stays
// reserved for the three age bands that drive the Programs dropdown and
// homepage cards). Support groups, individual counseling, and workshops come
// through as `serviceSection` cards from the Sanity body, so this page needs
// no CSS of its own.
class FamilyServices extends AsyncStatelessComponent {
  const FamilyServices({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('family-services');
    final title = page?.title ?? 'Family Services';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'Support groups, individual counseling, and parent workshops for families at Hagedorn Little Village School.',
        path: '/programs/family-services',
      ),
      ContentPage(
        breadcrumb: 'Programs › $title',
        title: title,
        children: [
          if (page != null) PortableTextView(page.body),
          const CtaBand(),
        ],
      ),
    ]);
  }
}
