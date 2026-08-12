import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';
import '../components/photo_placeholder.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/models/event_item.dart';
import '../util/date_format.dart';

// Receives its event pre-fetched from [App] — see app.dart for why detail
// pages take data as a constructor param instead of querying by slug.
class EventDetail extends StatelessComponent {
  final EventItem event;

  const EventDetail(this.event, {super.key});

  @override
  Component build(BuildContext context) {
    final heroUrl = event.cardImageUrl ?? event.flyerUrl;

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
          div(classes: 'detail-container', [
            div(classes: 'detail-meta-bar', [
              _metaItem('📅', [
                strong([.text(formatDate(event.eventDate))]),
              ]),
              _metaItem('📍', [.text(event.location)]),
              _metaItem('📝', [.text('Published ${formatDate(event.publishedDate)}')]),
            ]),
            div(
              classes: 'detail-hero',
              [
                if (heroUrl != null)
                  img(src: heroUrl, alt: 'Event photo', classes: 'detail-hero-image')
                else
                  PhotoPlaceholder('Event hero image', height: 320.px),
              ],
            ),
            div(classes: 'detail-body', [
              for (final paragraph in event.description.split('\n'))
                if (paragraph.trim().isNotEmpty) p([.text(paragraph)]),
            ]),
            if (event.ticketLink != null)
              div(classes: 'detail-cta', [
                a(href: event.ticketLink!, target: Target.blank, classes: 'detail-cta-btn', [
                  .text('Tickets / RSVP →'),
                ]),
              ]),
            if (event.photoGalleryUrls.isNotEmpty) ...[
              div(classes: 'evd-gallery-heading', [.text('Event photos')]),
              div(classes: 'evd-gallery-grid', [
                for (final url in event.photoGalleryUrls)
                  img(src: url, alt: 'Event photo', classes: 'evd-gallery-image'),
              ]),
            ],
          ]),
        ],
      ),
    ]);
  }

  static Component _metaItem(String icon, List<Component> content) {
    return div(classes: 'detail-meta-item', [
      span(classes: 'detail-meta-icon', [.text(icon)]),
      span(classes: 'detail-meta-text', content),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.evd-gallery-heading').styles(
      margin: .only(top: 26.px, bottom: 14.px),
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 19.px,
      fontWeight: .w600,
    ),
    css('.evd-gallery-grid').styles(
      display: .grid,
      gap: .all(10.px),
      raw: {'grid-template-columns': 'repeat(4, 1fr)'},
    ),
    css('.evd-gallery-image').styles(
      width: 100.percent,
      radius: .all(.circular(Radii.sm)),
      raw: {'aspect-ratio': '1', 'object-fit': 'cover'},
    ),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.evd-gallery-grid').styles(raw: {'grid-template-columns': 'repeat(2, 1fr)'}),
    ]),
  ];
}
