import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/collection_card.dart';
import '../components/content_page.dart';
import '../sanity/models/event_item.dart';
import '../sanity/models/news_post.dart';
import '../util/date_format.dart';

// Receives its data pre-fetched from [App] rather than querying Sanity
// itself, since [App] already needs the full lists at build time to
// generate one static route per news/event detail page (see app.dart).
class NewsEvents extends StatelessComponent {
  final List<NewsPost> newsPosts;
  final List<EventItem> events;

  const NewsEvents({required this.newsPosts, required this.events, super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'News & Events',
      title: 'News & Events',
      children: [
        if (events.isNotEmpty) ...[
          h2([.text('Events')]),
          div(classes: 'card-grid', [for (final event in events) _eventCard(event)]),
        ],
        h2([.text('Latest News')]),
        if (newsPosts.isEmpty)
          p([.text('No news posts yet.')])
        else
          div(classes: 'card-grid', [for (final post in newsPosts) _newsCard(post)]),
      ],
    );
  }

  static Component _newsCard(NewsPost post) {
    return CollectionCard(
      title: post.title,
      imageUrl: post.heroImageUrl,
      eyebrow: formatDate(post.publishedDate),
      excerpt: _excerpt(post.body),
      linkTo: post.slug != null ? '/news/${post.slug}' : null,
      externalHref: post.slug == null ? post.link : null,
    );
  }

  static Component _eventCard(EventItem event) {
    return CollectionCard(
      title: event.title,
      imageUrl: event.cardImageUrl ?? event.flyerUrl,
      eyebrow: '${formatDate(event.eventDate)} · ${event.location}',
      excerpt: _excerpt(event.description),
      linkTo: event.slug != null ? '/events/${event.slug}' : null,
      externalHref: event.slug == null ? event.ticketLink : null,
    );
  }

  static String? _excerpt(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length <= 140) return trimmed;
    return '${trimmed.substring(0, 140).trimRight()}…';
  }
}
