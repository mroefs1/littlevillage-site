import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/media.dart';

// Media › In The News (Step 21) — press coverage of the school.
//
// This is the only page in Steps 20-21 with a genuinely new layout, so it's
// the only one carrying its own CSS: a thumbnail beside a caption and a list
// of links. Everything else in the Media section reuses existing shared
// classes.
//
// Thumbnails come from the full-size scan through Sanity's image pipeline
// (see `pressItemListQuery`), not from WordPress's own 150x150 crops, which
// were far too small to display.
class MediaInTheNews extends AsyncStatelessComponent {
  const MediaInTheNews({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final items = await contentRepository.getPressItems();

    return .fragment([
      const SeoMeta(
        title: 'In The News | $siteName',
        description: 'Press coverage of Hagedorn Little Village School in Newsday, Long Island Herald, and more.',
        path: '/media/in-the-news',
      ),
      ContentPage(
        breadcrumb: 'Media › In The News',
        title: 'In The News',
        children: [
          if (items.isEmpty)
            div(classes: 'body-content', [p([.text('Press coverage will appear here soon.')])])
          else
            div(classes: 'press-list', [for (final item in items) _pressCard(item)]),
        ],
      ),
    ]);
  }

  static Component _pressCard(PressItem item) {
    return div(classes: 'press-item', [
      // Items without a usable image still lay out correctly — the thumbnail
      // column is simply omitted rather than left as an empty box.
      if (item.thumbnailUrl != null)
        div(classes: 'press-item-media', [
          img(
            src: item.thumbnailUrl!,
            alt: item.thumbnailAlt ?? '',
            classes: 'press-item-thumb',
            attributes: const {'loading': 'lazy'},
          ),
        ]),
      div(classes: 'press-item-body', [
        div(classes: 'press-item-meta', [.text(_meta(item))]),
        div(classes: 'press-item-title', [.text(item.title)]),
        if (item.links.isNotEmpty)
          div(classes: 'press-item-links', [
            for (final link in item.links)
              if (link.url case final url?)
                a(href: url, target: Target.blank, classes: 'press-item-link', [.text('${link.label} →')]),
          ]),
      ]),
    ]);
  }

  /// The legacy captions aren't parseable dates ("April 8-14, 2016", a bare
  /// "June 2026"), so `dateLabel` wins when set; otherwise the real date is
  /// formatted. Publication is appended when known — one item names none
  /// anywhere in the source.
  static String _meta(PressItem item) {
    final date = item.dateLabel ?? (item.date == null ? null : _formatDate(item.date!));
    return [date, item.publication].whereType<String>().join(' · ');
  }

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static String _formatDate(String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return iso;
    return '${_months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  }

  @css
  static List<StyleRule> get styles => [
    css('.press-list').styles(
      display: .flex,
      margin: .only(top: 8.px),
      flexDirection: .column,
      gap: .all(18.px),
    ),
    css('.press-item', [
      css('&').styles(
        display: .flex,
        padding: .all(20.px),
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.xl)),
        alignItems: .start,
        gap: .all(20.px),
        backgroundColor: Colors.white,
      ),
      css('.press-item-media').styles(
        width: 168.px,
        raw: {'flex': 'none'},
      ),
      css('.press-item-thumb').styles(
        display: .block,
        width: 100.percent,
        height: .auto,
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.sm)),
        backgroundColor: Colors.white,
      ),
      css('.press-item-body').styles(minWidth: 0.px, flex: Flex(grow: 1)),
      css('.press-item-meta').styles(
        color: AppColors.mutedTextLight,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 0.75.rem,
        fontWeight: .w700,
        textTransform: .upperCase,
        letterSpacing: 0.04.em,
      ),
      css('.press-item-title').styles(
        margin: .only(top: 6.px),
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.125.rem,
        fontWeight: .w600,
        lineHeight: 1.3.em,
      ),
      css('.press-item-links').styles(
        display: .flex,
        margin: .only(top: 10.px),
        flexWrap: .wrap,
        gap: .all(16.px),
      ),
      css('.press-item-link').styles(
        color: AppColors.coral,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 0.875.rem,
        fontWeight: .w700,
      ),
    ]),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.press-item').styles(flexDirection: .column, alignItems: .stretch),
      // Full-bleed thumbnail once stacked, rather than a narrow 168px strip
      // floating above the text.
      css('.press-item-media').styles(width: 100.percent),
    ]),
  ];
}
