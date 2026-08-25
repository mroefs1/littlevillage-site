import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// The Career Opportunities page (Step 20). Backed by the `careers` singleton:
// intro copy, the Indeed company-page link, and one flat list of positions
// that HR can add to or prune in Sanity as postings open and close.
//
// Every position link points out to Indeed, so this reuses the existing
// `.link-grid`/`.link-card` treatment already used for newsletter downloads
// and the Data Privacy PDFs — no CSS of its own.
class Careers extends AsyncStatelessComponent {
  const Careers({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final careers = await contentRepository.getCareersInfo();

    return .fragment([
      SeoMeta(
        title: 'Career Opportunities | $siteName',
        description: careers != null && !careers.intro.isEmpty
            ? truncateForMeta(careers.intro.plainText)
            : 'Current openings at Hagedorn Little Village School, a publicly funded not-for-profit special education school in Seaford, NY.',
        path: '/careers',
      ),
      ContentPage(
        breadcrumb: 'About › Career Opportunities',
        title: 'Career Opportunities',
        children: [
          if (careers != null) ...[
            PortableTextView(careers.intro),
            // Wrapped in the shared `.body-content` so the link picks up the
            // same body-copy and inline-link styling as portable text —
            // rather than this page defining a one-off rule for one link.
            if (careers.indeedUrl case final url?)
              div(classes: 'body-content', [
                p([a(href: url, target: Target.blank, [.text('See all current openings on Indeed →')])]),
              ]),
            for (final group in careers.grouped) ...[
              h2([.text('${group.title} Positions')]),
              div(classes: 'link-grid', [
                for (final position in group.positions)
                  a(href: position.url, target: Target.blank, classes: 'link-card', [
                    div(classes: 'link-card-title', [.text(position.title)]),
                    div(classes: 'link-card-cta', [.text('View on Indeed →')]),
                  ]),
              ]),
            ],
          ],
          const CtaBand(),
        ],
      ),
    ]);
  }
}
