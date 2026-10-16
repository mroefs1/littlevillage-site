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
// The homepage's "Services & Support" row links here. The body is a callout
// on where services take place, then the SEIT, Preschool Related Services and
// Elementary School Itinerant Services cards, copied as-is from the Preschool
// and Elementary `program` documents. They're deliberately copies, not
// references, so editing one doesn't update the other. All of it is Sanity
// content; this component only renders whatever `body` holds.
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
            : 'Itinerant special education and related services for preschool and elementary '
                  'children at Hagedorn Little Village School, in the home or at school.',
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
