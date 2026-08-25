import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';

// The Media hub (Step 21). The legacy `/home/media/` page has no content of
// its own to transcribe, but every other nav dropdown (Programs, About,
// Current Families) has a real page behind its parent link, so this exists
// rather than being an inert menu label.
//
// Reuses the `.link-grid`/`.link-card` treatment from Step 12 — no CSS of its
// own. Pictures is deliberately absent: the legacy version is a WordPress
// category archive, dropped for now.
class Media extends StatelessComponent {
  const Media({super.key});

  static const _sections = [
    (
      title: 'Newsletters',
      path: '/media/newsletters',
      body: 'Our monthly school newsletter, going back through the current school year.',
    ),
    (
      title: 'In The News',
      path: '/media/in-the-news',
      body: 'Press coverage of the school, from Newsday to Long Island Business News.',
    ),
    (
      title: 'Videos',
      path: '/media/videos',
      body: 'A look inside the school and the families we work with.',
    ),
  ];

  @override
  Component build(BuildContext context) {
    return .fragment([
      const SeoMeta(
        title: 'Media | $siteName',
        description: 'Newsletters, press coverage, and videos from Hagedorn Little Village School.',
        path: '/media',
      ),
      ContentPage(
        breadcrumb: 'Media',
        title: 'Media',
        children: [
          div(classes: 'link-grid', [
            for (final section in _sections)
              Link(
                to: section.path,
                classes: 'link-card',
                child: .fragment([
                  div(classes: 'link-card-title', [.text(section.title)]),
                  div(classes: 'link-card-body', [.text(section.body)]),
                  div(classes: 'link-card-cta', [.text('View →')]),
                ]),
              ),
          ]),
        ],
      ),
    ]);
  }
}
