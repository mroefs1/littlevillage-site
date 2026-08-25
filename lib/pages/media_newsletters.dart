import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/newsletter.dart';
import '../util/date_format.dart';

// Media › Newsletters (Step 21). The same `newsletter` documents that the
// News & Events page already lists — deliberately shown in both places, since
// newsletters are a different thing from news posts and events, and `/news`
// needed no change.
//
// Reuses the shared `.link-grid`/`.link-card` classes; no CSS of its own.
class MediaNewsletters extends AsyncStatelessComponent {
  const MediaNewsletters({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    // Well above the rolling school-year window the page actually holds, so
    // nothing is silently cut off as more are published.
    final newsletters = await contentRepository.getNewsletters(limit: 100);

    return .fragment([
      const SeoMeta(
        title: 'Newsletters | $siteName',
        description: 'Download the monthly newsletter from Hagedorn Little Village School.',
        path: '/media/newsletters',
      ),
      ContentPage(
        breadcrumb: 'Media › Newsletters',
        title: 'Newsletters',
        children: [
          // `.body-content` is the shared body-copy wrapper — there is no
          // sitewide subtitle class (every page defines its own), and this
          // page deliberately adds no CSS.
          div(classes: 'body-content', [
            p([.text('Our newsletter is emailed each month. Recent issues are collected here.')]),
          ]),
          if (newsletters.isEmpty)
            div(classes: 'body-content', [p([.text('Newsletters will appear here soon.')])])
          else
            div(classes: 'link-grid', [for (final newsletter in newsletters) _card(newsletter)]),
        ],
      ),
    ]);
  }

  static Component _card(Newsletter newsletter) {
    final content = [
      div(classes: 'link-card-title', [.text(newsletter.title)]),
      div(classes: 'link-card-body', [.text(formatDate(newsletter.publishedDate))]),
      if (newsletter.fileUrl != null) div(classes: 'link-card-cta', [.text('Download →')]),
    ];
    if (newsletter.fileUrl == null) return div(classes: 'link-card', content);
    return a(href: newsletter.fileUrl!, target: Target.blank, classes: 'link-card', content);
  }
}
