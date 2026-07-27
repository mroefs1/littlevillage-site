import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/models/event_item.dart';
import '../util/date_format.dart';

// Receives its event pre-fetched from [App] — see app.dart for why detail
// pages take data as a constructor param instead of querying by slug.
class EventDetail extends StatelessComponent {
  final EventItem event;

  const EventDetail(this.event, {super.key});

  @override
  Component build(BuildContext context) {
    final heroUrl = event.flyerUrl ?? event.cardImageUrl;

    return .fragment([
      SeoMeta(
        title: '${event.title} | $siteName',
        description: event.description.trim().isNotEmpty
            ? truncateForMeta(event.description)
            : '${formatDate(event.eventDate)} at ${event.location} — an event at $siteName.',
        path: '/events/${event.slug}',
        image: heroUrl,
        type: 'article',
      ),
      ContentPage(
        breadcrumb: 'News & Events › ${event.title}',
        title: event.title,
        children: [
          div(classes: 'detail-meta', [.text('${formatDate(event.eventDate)} · ${event.location}')]),
          if (heroUrl != null) img(src: heroUrl, alt: 'Hero photo', classes: 'detail-hero'),
          div(classes: 'detail-body', [
            for (final paragraph in event.description.split('\n'))
              if (paragraph.trim().isNotEmpty) p([.text(paragraph)]),
          ]),
          if (event.ticketLink != null)
            a(href: event.ticketLink!, target: Target.blank, classes: 'detail-link', [.text('Tickets / RSVP →')]),
          if (event.photoGalleryUrls.isNotEmpty)
            div(classes: 'gallery-grid', [
              for (final url in event.photoGalleryUrls) img(src: url, alt: 'Event photo', classes: 'gallery-image'),
            ]),
        ],
      ),
    ]);
  }
}
