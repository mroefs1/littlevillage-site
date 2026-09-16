import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// Related Services (Step 30) — a standalone `page` document, same shape as
// Family Services and CPSE Evaluations.
//
// The homepage's "Services & Support" row links here, which is why the page
// exists now: the redesign's third card names Related Services, and pointing
// a live card at a route that does not resolve is worse than a short page.
// The content is currently a deliberate placeholder — the department's own
// documentation is still to come, and when it arrives this is pure content
// entry in Sanity with no deploy, since the page renders whatever `body`
// holds.
class RelatedServices extends AsyncStatelessComponent {
  const RelatedServices({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('related-services');
    final title = page?.title ?? 'Related Services';

    return .fragment([
      SeoMeta(
        title: '$title | $siteName',
        description: page != null && !page.body.isEmpty
            ? truncateForMeta(page.body.plainText)
            : 'Counseling, social work, nursing, adaptive physical education and family training '
                  'at Hagedorn Little Village School.',
        path: '/programs/related-services',
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
