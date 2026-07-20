import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';
import '../sanity/models/news_post.dart';
import '../util/date_format.dart';

// Receives its post pre-fetched from [App] — see app.dart for why detail
// pages take data as a constructor param instead of querying by slug.
class NewsDetail extends StatelessComponent {
  final NewsPost post;

  const NewsDetail(this.post, {super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'News & Events › ${post.title}',
      title: post.title,
      children: [
        div(classes: 'detail-meta', [.text(formatDate(post.publishedDate))]),
        if (post.heroImageUrl != null) img(src: post.heroImageUrl!, alt: '', classes: 'detail-hero'),
        div(classes: 'detail-body', [
          for (final paragraph in post.body.split('\n'))
            if (paragraph.trim().isNotEmpty) p([.text(paragraph)]),
        ]),
        if (post.link != null)
          a(href: post.link!, target: Target.blank, classes: 'detail-link', [.text('Read more →')]),
      ],
    );
  }
}
