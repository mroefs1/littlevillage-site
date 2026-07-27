import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

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
// three feature cards (calendar / documents / parent portal), the calendar
// embed, a documents list backed by the `doc` Sanity type (unused until
// now), and a static quick-links band. Parent Association / Summer
// Recreation / Careers have no Sanity content type yet and no portal
// backend exists (see CLAUDE.md's "Data layer"), so those stay stub links.
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
            a(href: '#calendar', classes: 'cf-feature-card', [
              div(classes: 'cf-feature-icon', [.text('📅')]),
              div(classes: 'cf-feature-title', [.text('School Calendar')]),
              div(classes: 'cf-feature-desc', [
                .text('Closings, breaks, half-days, and key dates for the school year.'),
              ]),
              div(classes: 'cf-feature-cta', [.text('View full calendar →')]),
            ]),
            a(href: '#documents', classes: 'cf-feature-card', [
              div(classes: 'cf-feature-icon', [.text('📄')]),
              div(classes: 'cf-feature-title', [.text('Important Documents')]),
              div(classes: 'cf-feature-desc', [
                .text('Handbooks, one-page calendars, and district paperwork.'),
              ]),
              div(classes: 'cf-feature-cta', [.text('Browse documents →')]),
            ]),
            a(href: '#', classes: 'cf-feature-card cf-feature-card-portal', [
              div(classes: 'cf-feature-icon cf-feature-icon-portal', [.text('🔐')]),
              div(classes: 'cf-feature-title', [.text('Parent Portal')]),
              div(classes: 'cf-feature-desc', [
                .text("Sign in to view your child's records, progress, and messages."),
              ]),
              div(classes: 'cf-feature-cta', [.text('Sign in →')]),
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
            a(href: '#', [.text('↳ Parent Association')]),
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
      color: AppColors.body,
      fontSize: 15.px,
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
        padding: .all(18.px),
        border: .all(color: AppColors.borderMedium, width: 2.px),
        radius: .all(.circular(10.px)),
        flex: Flex(grow: 1),
        backgroundColor: Colors.white,
      ),
      css('.cf-feature-title').styles(
        margin: .only(top: 12.px),
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 18.px,
        fontWeight: .w700,
      ),
      css('.cf-feature-desc').styles(
        margin: .only(top: 4.px),
        color: AppColors.body,
        fontSize: 13.px,
        lineHeight: 1.5.em,
      ),
      css('.cf-feature-cta').styles(
        margin: .only(top: 10.px),
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
        fontWeight: .w700,
      ),
    ]),
    css('.cf-feature-card-portal').styles(backgroundColor: AppColors.lightBlueTint),
    css('.cf-feature-icon').styles(
      display: .flex,
      width: 56.px,
      height: 56.px,
      border: .all(color: AppColors.placeholderBorder, width: 2.px, style: .dashed),
      radius: .all(.circular(8.px)),
      justifyContent: .center,
      alignItems: .center,
      fontSize: 22.px,
      raw: {
        'background-image':
            'repeating-linear-gradient(45deg, ${AppColors.borderLight.value}, ${AppColors.borderLight.value} 8px, ${AppColors.placeholderStripe.value} 8px, ${AppColors.placeholderStripe.value} 16px)',
      },
    ),
    css('.cf-feature-icon-portal').styles(
      border: .all(color: AppColors.primary, width: 2.px, style: .dashed),
      raw: {
        'background-image':
            'repeating-linear-gradient(45deg, ${AppColors.pillTint.value}, ${AppColors.pillTint.value} 8px, ${AppColors.lightBlueTint.value} 8px, ${AppColors.lightBlueTint.value} 16px)',
      },
    ),

    css('.cf-section').styles(
      padding: .symmetric(vertical: 20.px, horizontal: 22.px),
      margin: .only(top: 20.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
    ),
    css('.cf-section h2').styles(margin: .zero),
    css('.cf-calendar-embed').styles(
      display: .block,
      width: 100.percent,
      margin: .only(top: 14.px),
      border: .none,
      radius: .all(.circular(8.px)),
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
        border: .all(color: AppColors.borderLight, width: 2.px),
        radius: .all(.circular(8.px)),
        alignItems: .center,
        gap: .all(10.px),
      ),
      css('.cf-document-title').styles(
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
      ),
    ]),

    css('.cf-quicklinks').styles(
      display: .flex,
      padding: .symmetric(vertical: 16.px, horizontal: 22.px),
      margin: .only(top: 20.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
      gap: .all(26.px),
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 15.px,
      backgroundColor: AppColors.shadedBg,
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
