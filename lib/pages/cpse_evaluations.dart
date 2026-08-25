import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// The CPSE Evaluations page (Step 18) — a standalone `page` document like
// Therapeutic Services, not a `program` (that type stays reserved for the
// three age bands that drive the Programs dropdown and homepage cards). Its
// referral/evaluation/eligibility band and bulleted evaluation areas come
// straight from the Sanity body, so this page needs no CSS of its own: the
// `processStep` cards are styled by `portable_text_view.dart` and the closing
// band is the shared `CtaBand` already used by every program page.
class CpseEvaluations extends AsyncStatelessComponent {
  const CpseEvaluations({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('cpse-evaluations');
    final title = page?.title ?? 'CPSE Evaluations';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'Free preschool special education evaluations at Hagedorn Little Village School, a New York State approved evaluation site.',
        path: '/programs/cpse-evaluations',
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
