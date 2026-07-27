import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'collection_card.dart';

enum _Filter { all, news, events }

// The one interactive piece of the News & Events page: an All/News/Events
// toggle over the two card grids below it. Cards are passed in as plain maps
// (matching [CollectionCard]'s fields) since @client parameters must be
// serializable — see faq_accordion.dart for the same pattern.
@client
class NewsEventsFilter extends StatefulComponent {
  final List<Map<String, String?>> newsItems;
  final List<Map<String, String?>> eventItems;

  const NewsEventsFilter({required this.newsItems, required this.eventItems, super.key});

  @override
  State<NewsEventsFilter> createState() => _NewsEventsFilterState();

  @css
  static List<StyleRule> get styles => [
    css('.filter-pills').styles(display: .flex, margin: .only(top: 6.px), gap: .all(10.px)),
    css('.filter-pill', [
      css('&').styles(
        padding: .symmetric(vertical: 7.px, horizontal: 16.px),
        border: .all(color: AppColors.borderMedium, width: 1.5.px),
        radius: .all(.circular(20.px)),
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
        fontWeight: .w700,
        backgroundColor: Colors.white,
        raw: {'cursor': 'pointer'},
      ),
      css('&.active').styles(
        border: .all(color: AppColors.primary, width: 1.5.px),
        color: Colors.white,
        backgroundColor: AppColors.primary,
      ),
    ]),
  ];
}

class _NewsEventsFilterState extends State<NewsEventsFilter> {
  _Filter _filter = _Filter.all;

  @override
  Component build(BuildContext context) {
    final showEvents = _filter != _Filter.news;
    final showNews = _filter != _Filter.events;

    return .fragment([
      div(
        classes: 'filter-pills',
        attributes: const {'role': 'group', 'aria-label': 'Filter by type'},
        [
          _pill('All', _Filter.all),
          _pill('News', _Filter.news),
          _pill('Events', _Filter.events),
        ],
      ),
      if (showEvents && component.eventItems.isNotEmpty) ...[
        h2([.text('Upcoming Events')]),
        div(classes: 'card-grid', [for (final item in component.eventItems) _card(item)]),
      ],
      if (showNews) ...[
        h2([.text('Latest News')]),
        if (component.newsItems.isEmpty)
          p([.text('No news posts yet.')])
        else
          div(classes: 'card-grid', [for (final item in component.newsItems) _card(item)]),
      ],
    ]);
  }

  Component _pill(String label, _Filter value) {
    final isActive = _filter == value;
    return button(
      classes: 'filter-pill${isActive ? ' active' : ''}',
      onClick: () => setState(() => _filter = value),
      attributes: {'aria-pressed': '$isActive'},
      [.text(label)],
    );
  }

  static Component _card(Map<String, String?> item) {
    return CollectionCard(
      title: item['title']!,
      imageUrl: item['imageUrl'],
      imageAlt: item['imageAlt'] ?? 'Photo',
      eyebrow: item['eyebrow'],
      excerpt: item['excerpt'],
      linkTo: item['linkTo'],
      externalHref: item['externalHref'],
    );
  }
}
