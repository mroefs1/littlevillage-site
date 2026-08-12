import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/document.dart';

// The three HLVS calendars (school, closures, events) from the Flutter
// app's Google Calendar integration, combined into one public embed. There's
// no lightweight "closure/key date" content type in Sanity yet — `event`
// requires two images and is the wrong shape for a one-line closing notice —
// so per CLAUDE.md this section embeds Google Calendar directly rather than
// modeling that content in Sanity. Requires each calendar to be shared
// publicly (Settings > Access permissions > "Make available to public") or
// the embed renders blank.
final Uri _calendarEmbedUri = Uri.https('calendar.google.com', '/calendar/embed', {
  'src': const [
    'c_220a631ee1aeca2a06a2f641029bf91059567f87a78f315ea71c5f7c06a2280e@group.calendar.google.com',
    'c_3c55925e16db2264dc1027e26bcad3a2fe6ca1d84caf49e0978b346c9a60e611@group.calendar.google.com',
    'c_e68a5fa70aaf9c8a88752ac03fb1c0f3934c6c7758f886b2690516cf118ee8d2@group.calendar.google.com',
  ],
  'ctz': 'America/New_York',
});

// Per the design handoff (current-families.html): a "welcome back" hero,
// feature cards (calendar / documents), the calendar embed, a documents
// list backed by the `doc` Sanity type (unused until now), and a static
// quick-links band. No parent portal — not a planned feature (see
// CLAUDE.md's "Data layer"). Summer Recreation / Careers have no Sanity
// content type yet, so those stay stub links — Parent Association links to
// its real page (Batch 10).
class CurrentFamilies extends AsyncStatelessComponent {
  const CurrentFamilies({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final documents = await contentRepository.getDocuments();

    return .fragment([
      const SeoMeta(
        title: 'Current Families | $siteName',
        description:
            'Everything current Little Village families need — calendar, forms, and quick links — in one place.',
        path: '/current-families',
      ),
      ContentPage(
        breadcrumb: 'Current Families',
        title: 'Welcome back.',
        children: [
          p(classes: 'cf-subtitle', [
            .text(
              'Everything current Little Village families need — calendar, forms, and quick links — in one place.',
            ),
          ]),
          div(classes: 'cf-features', [
            Link(
              to: '/parent-association',
              classes: 'cf-feature-card',
              children: [
                div(classes: 'cf-feature-icon', [.text('🤝')]),
                div(classes: 'cf-feature-title', [.text('Parent Association')]),
                div(classes: 'cf-feature-desc', [
                  .text('Board members, dues, and upcoming PA events and meetings.'),
                ]),
                div(classes: 'cf-feature-cta', [.text('Visit Parent Association →')]),
              ],
            ),
            a(href: '/current-families#documents', classes: 'cf-feature-card', [
              div(classes: 'cf-feature-icon', [.text('📄')]),
              div(classes: 'cf-feature-title', [.text('Important Documents')]),
              div(classes: 'cf-feature-desc', [
                .text('Handbooks, one-page calendars, and district paperwork.'),
              ]),
              div(classes: 'cf-feature-cta', [.text('Browse documents →')]),
            ]),
          ]),
          section(classes: 'cf-section', id: 'calendar', [
            h2([.text('Upcoming closures & key dates')]),
            iframe(
              src: _calendarEmbedUri.toString(),
              height: 600,
              loading: MediaLoading.lazy,
              classes: 'cf-calendar-embed',
              attributes: const {'title': 'School calendar — closures, breaks, and key dates'},
              const [],
            ),
          ]),
          section(classes: 'cf-section', id: 'documents', [
            h2([.text('Documents')]),
            if (documents.isEmpty)
              p([.text('Documents are coming soon.')])
            else
              div(classes: 'cf-documents', [for (final document in documents) _documentCard(document)]),
          ]),
          div(classes: 'cf-quicklinks', [
            Link(to: '/parent-association', child: .text('↳ Parent Association')),
            a(href: '#', [.text('↳ Summer Recreation')]),
            a(href: '#', [.text('↳ Careers & staff portal')]),
          ]),
        ],
      ),
    ]);
  }

  static Component _documentCard(ParentDocument document) {
    final content = [
      span([.text('📄')]),
      span(classes: 'cf-document-title', [.text(document.title)]),
    ];
    if (document.fileUrl != null) {
      return a(href: document.fileUrl!, target: Target.blank, classes: 'cf-document-card', content);
    }
    return div(classes: 'cf-document-card', content);
  }

  @css
  static List<StyleRule> get styles => [
    css('.cf-subtitle').styles(
      maxWidth: 640.px,
      margin: .only(top: 10.px),
      color: AppColors.mutedText,
      fontSize: 16.px,
      lineHeight: 1.55.em,
    ),

    css('.cf-features').styles(
      display: .flex,
      margin: .only(top: 16.px),
      gap: .all(16.px),
    ),
    css('.cf-feature-card', [
      css('&').styles(
        display: .block,
        padding: .all(20.px),
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.lg)),
        flex: Flex(grow: 1),
        backgroundColor: Colors.white,
      ),
      css('.cf-feature-title').styles(
        margin: .only(top: 12.px),
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 17.px,
        fontWeight: .w600,
      ),
      css('.cf-feature-desc').styles(
        margin: .only(top: 4.px),
        color: AppColors.mutedTextMid,
        fontSize: 13.px,
        lineHeight: 1.5.em,
      ),
      css('.cf-feature-cta').styles(
        margin: .only(top: 10.px),
        color: AppColors.coral,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 14.px,
        fontWeight: .w700,
      ),
    ]),
    // First card (Parent Association) gets a peach icon tile, second
    // (Documents) mint — same per-icon differentiation as the homepage's
    // Current Families band in 11.3.
    css('.cf-feature-icon').styles(
      display: .flex,
      width: 56.px,
      height: 56.px,
      radius: .all(.circular(Radii.sm)),
      justifyContent: .center,
      alignItems: .center,
      fontSize: 22.px,
      raw: {
        'background-image':
            'repeating-linear-gradient(135deg, ${AppColors.peach.value}, ${AppColors.peach.value} 8px, ${AppColors.peachDark.value} 8px, ${AppColors.peachDark.value} 16px)',
      },
    ),
    css('.cf-feature-card:nth-child(2) .cf-feature-icon').styles(
      raw: {
        'background-image':
            'repeating-linear-gradient(135deg, ${AppColors.mint.value}, ${AppColors.mint.value} 8px, ${AppColors.mintDark.value} 8px, ${AppColors.mintDark.value} 16px)',
      },
    ),

    css('.cf-section').styles(
      padding: .symmetric(vertical: 20.px, horizontal: 22.px),
      margin: .only(top: 20.px),
      border: .all(color: AppColors.line, width: 1.px),
      radius: .all(.circular(Radii.xl)),
    ),
    css('.cf-section h2').styles(margin: .zero, fontWeight: .w600),
    css('.cf-calendar-embed').styles(
      display: .block,
      width: 100.percent,
      margin: .only(top: 14.px),
      border: .none,
      radius: .all(.circular(Radii.sm)),
    ),

    css('.cf-documents').styles(
      display: .grid,
      margin: .only(top: 14.px),
      gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))])),
      gap: .all(12.px),
    ),
    css('.cf-document-card', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 10.px, horizontal: 14.px),
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.sm)),
        alignItems: .center,
        gap: .all(10.px),
        backgroundColor: Colors.white,
      ),
      css('.cf-document-title').styles(
        color: AppColors.navy,
        fontSize: 14.px,
        fontWeight: .w600,
      ),
    ]),

    // Quick-links row — light sky band, not a bordered/shaded box.
    css('.cf-quicklinks').styles(
      display: .flex,
      padding: .symmetric(vertical: 16.px, horizontal: 22.px),
      margin: .only(top: 20.px),
      radius: .all(.circular(Radii.xl)),
      gap: .all(26.px),
      color: AppColors.coral,
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: AppColors.sky,
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.cf-features').styles(flexDirection: .column),
      css('.cf-documents').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.cf-quicklinks').styles(flexDirection: .column, gap: .all(10.px)),
      css('.cf-calendar-embed').styles(height: 400.px),
    ]),
  ];
}
