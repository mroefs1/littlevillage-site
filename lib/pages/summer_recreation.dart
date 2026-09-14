import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// The Summer Recreation Program page (Step 19) — a standalone `page` document
// like Therapeutic Services and CPSE Evaluations, not a `program` (that type
// stays reserved for the three age bands that drive the Programs dropdown and
// homepage cards). Routed on the legacy `summer-carp` slug: CARP is the
// program's actual name (Creative Arts and Recreation Program), not a typo, so
// the acronym is kept rather than genericized away.
class SummerRecreation extends AsyncStatelessComponent {
  const SummerRecreation({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('summer-carp');
    final title = page?.title ?? 'Summer Recreation Program';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'Summer CARP, the Creative Arts and Recreation Program at Hagedorn Little Village School.',
        path: '/programs/summer-carp',
      ),
      ContentPage(
        breadcrumb: 'Programs › $title',
        title: title,
        heroImage: page?.heroImage,
        gallery: page?.images ?? const [],
        children: [
          if (page != null) PortableTextView(page.body),
          const CtaBand(),
        ],
      ),
    ]);
  }
}
