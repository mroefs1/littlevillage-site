import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';
import '../components/news_events_filter.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/models/event_item.dart';
import '../sanity/models/news_post.dart';
import '../sanity/models/newsletter.dart';
import '../util/date_format.dart';

// Receives its data pre-fetched from [App] rather than querying Sanity
// itself, since [App] already needs the full lists at build time to
// generate one static route per news/event detail page (see app.dart).
class NewsEvents extends StatelessComponent {
  final List<NewsPost> newsPosts;
  final List<EventItem> events;
  final List<Newsletter> newsletters;

  const NewsEvents({
    required this.newsPosts,
    required this.events,
    required this.newsletters,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return .fragment([
      const SeoMeta(
        title: 'News & Events | $siteName',
        description: 'Fundraisers, milestones, and everything happening around Hagedorn Little Village School.',
        path: '/news',
      ),
      ContentPage(
        breadcrumb: 'News & Events',
        title: 'News & Events',
        children: [
          p([.text('Fundraisers, milestones, and everything happening around the school.')]),
          NewsEventsFilter(
            newsItems: [for (final post in newsPosts) _newsItem(post)],
            eventItems: [for (final event in events) _eventItem(event)],
          ),
          if (newsletters.isNotEmpty) ...[
            h2([.text('Newsletters')]),
            div(classes: 'link-grid', [for (final newsletter in newsletters) _newsletterCard(newsletter)]),
          ],
        ],
      ),
    ]);
  }

  static Map<String, String?> _newsItem(NewsPost post) {
    return {
      'title': post.title,
      'imageUrl': post.heroImageUrl,
      'eyebrow': formatDate(post.publishedDate),
      'excerpt': _excerpt(post.body),
      'linkTo': post.slug != null ? '/news/${post.slug}' : null,
      'externalHref': post.slug == null ? post.link : null,
    };
  }

  static Map<String, String?> _eventItem(EventItem event) {
    return {
      'title': event.title,
      'imageUrl': event.cardImageUrl ?? event.flyerUrl,
      'eyebrow': '${formatDate(event.eventDate)} · ${event.location}',
      'excerpt': _excerpt(event.description),
      'linkTo': event.slug != null ? '/events/${event.slug}' : null,
      'externalHref': event.slug == null ? event.ticketLink : null,
    };
  }

  static Component _newsletterCard(Newsletter newsletter) {
    final content = [
      div(classes: 'link-card-title', [.text(newsletter.title)]),
      div(classes: 'link-card-body', [.text(formatDate(newsletter.publishedDate))]),
      if (newsletter.fileUrl != null) div(classes: 'link-card-cta', [.text('Download →')]),
    ];
    if (newsletter.fileUrl != null) {
      return a(href: newsletter.fileUrl!, target: Target.blank, classes: 'link-card', content);
    }
    return div(classes: 'link-card', content);
  }

  static String? _excerpt(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length <= 140) return trimmed;
    return '${trimmed.substring(0, 140).trimRight()}…';
  }
}
