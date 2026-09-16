import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/icons.dart';
import '../components/photo_placeholder.dart';
import '../components/quick_links.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/image_url.dart';
import '../sanity/models/event_item.dart';
import '../sanity/models/homepage_content.dart';
import '../sanity/models/news_post.dart';
import '../sanity/models/program.dart';
import '../util/date_format.dart';

// Receives its news/events/homepage/programs pre-fetched from [App]
// (already fetching the full lists for static routing purposes) rather than
// querying Sanity again — see app.dart.
class Home extends StatelessComponent {
  final List<NewsPost> newsPosts;
  final List<EventItem> events;
  final Homepage homepage;
  final List<Program> programs;

  const Home({
    required this.newsPosts,
    required this.events,
    required this.homepage,
    required this.programs,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return .fragment([
      const SeoMeta(
        title: '$siteName | Special Education, Early Intervention & Preschool on Long Island',
        description: defaultMetaDescription,
        path: '/',
      ),
      div(classes: 'home', [
        _hero(),
        const QuickLinks(),
        _programsSection(programs, homepage.programsIntro),
        _servicesSection(homepage.serviceCards),
        _newsEvents(),
        _currentFamilies(),
        _donateBand(),
      ]),
    ]);
  }

  // Full-bleed photo band with the headline over it. Every piece of copy
  // falls back to the previous hard-coded wording, so an unpublished or
  // half-filled `homepage` singleton degrades to a correct hero rather than
  // blank text — the homepage is the worst route to let a content mistake
  // break.
  Component _hero() {
    final image = homepage.heroImage;
    return header(classes: 'home-hero', [
      if (image != null)
        img(
          src: sanityImageUrl(image.url, width: 2000),
          alt: image.alt,
          classes: 'home-hero-img',
          styles: switch (image.objectPosition) {
            final position? => Styles(raw: {'object-position': position}),
            null => null,
          },
          // The hero is the first thing painted — never defer it.
          attributes: {'fetchpriority': 'high', 'decoding': 'async'},
        ),
      // Separate element rather than a background-image on the band, so the
      // scrim sits above the photo and below the copy without the copy
      // inheriting any of it.
      div(classes: 'home-hero-scrim', []),
      div(classes: 'home-hero-copy', [
        h1([.text(homepage.heroHeadline ?? 'A place where your child is understood — and so are you.')]),
        p([
          .text(
            homepage.heroSubhead ??
                'Specialized education and on-site therapy, at no direct cost to your family. '
                    'Serving Long Island families for over 50 years.',
          ),
        ]),
        div(classes: 'hero-ctas', [
          Link(
            to: '/programs',
            classes: 'btn-primary',
            child: .text(homepage.heroPrimaryCtaLabel ?? 'View all programs'),
          ),
          Link(
            to: '/contact',
            classes: 'btn-secondary',
            child: .text(homepage.heroSecondaryCtaLabel ?? 'Request Information'),
          ),
        ]),
      ]),
    ]);
  }

  // Both card rows share one builder and one set of CSS rules — they are the
  // same card, differing only in where their content comes from and which
  // tint each position gets (see `.programs-cards` / `.services-cards`).
  static Component _card({
    required String eyebrow,
    required String title,
    required String blurb,
    required String path,
    String? imageUrl,
    String? imageAlt,
    String? objectPosition,
  }) {
    return Link(
      to: path,
      classes: 'home-card',
      child: .fragment([
        if (imageUrl != null)
          img(
            // 3-up at the 1180px container is ~370px wide, so 760 covers 2x.
            src: sanityImageUrl(imageUrl, width: 760),
            alt: imageAlt ?? '',
            classes: 'home-card-photo',
            styles: switch (objectPosition) {
              final position? => Styles(raw: {'object-position': position}),
              null => null,
            },
            attributes: const {'loading': 'lazy', 'decoding': 'async'},
          )
        else
          PhotoPlaceholder('photo', height: 170.px),
        div(classes: 'home-card-body', [
          div(classes: 'home-card-eyebrow', [.text(eyebrow)]),
          div(classes: 'home-card-title', [.text(title)]),
          div(classes: 'home-card-blurb', [.text(blurb)]),
          // A span, not a nested anchor: the whole card is already the link.
          span(classes: 'home-card-cta', [.text('Learn more →')]),
        ]),
      ]),
    );
  }

  // Driven entirely by the three `program` documents. The slug order is fixed
  // here because Sanity returns them unordered and they must read youngest to
  // oldest; the eyebrow, title, blurb and photo are all the document's own.
  static Component _programsSection(List<Program> programs, String? intro) {
    const slugs = ['early-intervention', 'preschool', 'elementary'];
    const fallbackBlurbs = {
      'early-intervention': 'Home- & center-based support for your baby or toddler.',
      'preschool': 'Small classes pairing learning with therapy.',
      'elementary': "A full school day built around each child's IEP.",
    };
    final ordered = [
      for (final slug in slugs)
        if (_programForSlug(programs, slug) case final program?) program,
    ];
    return section(classes: 'home-section programs-section', [
      div(classes: 'home-section-inner', [
        h2(classes: 'home-section-title', [.text('Educational Programs')]),
        if (intro != null) p(classes: 'home-section-intro', [.text(intro)]),
        div(classes: 'home-cards programs-cards', [
        for (final program in ordered)
          _card(
            eyebrow: program.ageRange ?? '',
            title: program.title,
            blurb: program.cardBlurb ?? fallbackBlurbs[program.slug] ?? '',
            path: '/programs/${program.slug}',
            imageUrl: program.imageUrl,
            imageAlt: program.title,
          ),
        ]),
      ]),
    ]);
  }

  static Program? _programForSlug(List<Program> programs, String slug) {
    for (final program in programs) {
      if (program.slug == slug) return program;
    }
    return null;
  }

  // Editorial, from the `homepage` singleton. Renders nothing at all when no
  // cards are configured, rather than an empty headed section.
  static Component _servicesSection(List<ServiceCard> cards) {
    if (cards.isEmpty) return .fragment([]);
    return section(classes: 'home-section services-section', [
      div(classes: 'home-section-inner', [
        h2(classes: 'home-section-title', [.text('Services & Support')]),
        div(classes: 'home-cards services-cards', [
        for (final card in cards)
          _card(
            eyebrow: card.eyebrow,
            title: card.title,
            blurb: card.blurb,
            path: card.path,
            imageUrl: card.image?.url,
            imageAlt: card.image?.alt,
            objectPosition: card.image?.objectPosition,
          ),
        ]),
      ]),
    ]);
  }

  Component _newsEvents() {
    return section(classes: 'home-section news-events-section', [
      div(classes: 'home-section-inner home-news-events', [
        div(classes: 'home-news', [
          h2(classes: 'home-column-title', [.text('Latest News')]),
          if (newsPosts.isEmpty)
            p(classes: 'home-empty', [.text('No news posts yet.')])
          else
            div(classes: 'home-rows', [for (final post in newsPosts) _newsRow(post)]),
        ]),
        div(classes: 'home-events', [
          h2(classes: 'home-column-title', [.text('Upcoming Events')]),
          if (events.isEmpty)
            p(classes: 'home-empty', [.text('No upcoming events yet.')])
          else
            div(classes: 'home-rows', [for (final event in events) _eventRow(event)]),
        ]),
      ]),
    ]);
  }

  // One preview line for a listing row. `news.body` and `event.description`
  // are both plain `text` fields in Sanity, so there is nothing to strip —
  // but they are full articles, so they get cut at a word boundary rather
  // than mid-word, and only when actually over length (a short body is left
  // alone rather than gaining a pointless ellipsis).
  static String? _excerpt(String? source, {int maxChars = 110}) {
    if (source == null) return null;
    final text = source.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty) return null;
    if (text.length <= maxChars) return text;
    final cut = text.substring(0, maxChars);
    final lastSpace = cut.lastIndexOf(' ');
    return '${(lastSpace > 40 ? cut.substring(0, lastSpace) : cut).trimRight()}…';
  }

  static Component _newsRow(NewsPost post) {
    final excerpt = _excerpt(post.body);
    final content = [
      if (post.heroImageUrl != null)
        img(
          src: sanityImageUrl(post.heroImageUrl!, width: 240),
          alt: '',
          classes: 'home-thumb',
          attributes: const {'loading': 'lazy', 'decoding': 'async'},
        ),
      div(classes: 'home-row-body', [
        div(classes: 'home-row-title', [.text(post.title)]),
        div(classes: 'home-row-meta', [.text(formatDate(post.publishedDate))]),
        if (excerpt != null) div(classes: 'home-row-excerpt', [.text(excerpt)]),
      ]),
    ];
    if (post.slug != null) {
      return Link(to: '/news/${post.slug}', classes: 'home-row', child: .fragment(content));
    }
    if (post.link != null) {
      return a(href: post.link!, target: Target.blank, classes: 'home-row', content);
    }
    return div(classes: 'home-row', content);
  }

  // The event row drops the thumbnail the old layout carried: the coral date
  // badge is the mockup's visual anchor, and a photo as well leaves no room
  // for the title beside them.
  static Component _eventRow(EventItem event) {
    final excerpt = _excerpt(event.description);
    final content = [
      div(classes: 'home-event-date', [
        div(classes: 'home-event-month', [.text(monthAbbr(event.eventDate))]),
        div(classes: 'home-event-day', [.text('${event.eventDate.day}')]),
      ]),
      div(classes: 'home-row-body', [
        div(classes: 'home-row-title', [.text(event.title)]),
        if (event.location.isNotEmpty) div(classes: 'home-row-meta', [.text(event.location)]),
        if (excerpt != null) div(classes: 'home-row-excerpt', [.text(excerpt)]),
      ]),
    ];
    if (event.slug != null) {
      return Link(to: '/events/${event.slug}', classes: 'home-row', child: .fragment(content));
    }
    return div(classes: 'home-row', content);
  }

  static Component _currentFamilies() {
    return div(classes: 'current-families', [
      div(classes: 'current-families-header', [
        div(classes: 'current-families-title', [
          .text('Already part of Little Village? '),
          span(classes: 'current-families-title-accent', [.text('Welcome back.')]),
        ]),
        // Was a dead `href="#"` stub; the mockup replaces it with a link to
        // the section it heads, which is a real page.
        Link(
          to: '/current-families',
          classes: 'current-families-portal',
          child: .text('Current Families →'),
        ),
      ]),
      div(classes: 'current-families-body', [
        Link(
          to: '/current-families',
          classes: 'current-families-feature',
          child: .fragment([
            div(classes: 'current-families-icon', [appIcon(AppIcons.calendar)]),
            div([
              div(classes: 'current-families-feature-title', [.text('School Calendar')]),
              div(classes: 'current-families-feature-desc', [.text('Closings, breaks & key dates at a glance.')]),
              div(classes: 'current-families-feature-cta', [.text('View calendar →')]),
            ]),
          ]),
        ),
        Link(
          to: '/current-families',
          classes: 'current-families-feature',
          child: .fragment([
            div(classes: 'current-families-icon', [appIcon(AppIcons.document)]),
            div([
              div(classes: 'current-families-feature-title', [.text('Important Documents')]),
              div(classes: 'current-families-feature-desc', [.text('Forms, handbooks & lunch menus.')]),
              div(classes: 'current-families-feature-cta', [.text('Browse documents →')]),
            ]),
          ]),
        ),
        div(classes: 'current-families-links', [
          Link(to: '/parent-association', child: .text('↳ Parent Association')),
          // Both of these pointed at /current-families, which was wrong for
          // Summer Recreation and out of date for Careers (which has had its
          // own page since Step 20).
          Link(to: '/programs/summer-carp', child: .text('↳ Summer Recreation')),
          Link(to: '/careers', child: .text('↳ Careers & staff portal')),
        ]),
      ]),
    ]);
  }

  static Component _donateBand() {
    return div(classes: 'donate-band', [
      div([
        div(classes: 'donate-band-title', [.text('Your gift keeps it free for every family.')]),
        div(classes: 'donate-band-subtitle', [.text("Events & donations fund what public money doesn't.")]),
      ]),
      Link(to: '/support-us', classes: 'donate-band-button', child: .text('♥ Donate')),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.home', [
      css('&').styles(
        display: .flex,
        padding: .only(bottom: 30.px),
        flexDirection: .column,
      ),

      // Hero — a full-bleed photo band. The photo, the scrim and the copy are
      // three stacked layers rather than a background-image plus text, so the
      // photo can be a real <img> with alt text and Sanity's hotspot applied
      // as object-position.
      css('.home-hero').styles(
        display: .flex,
        position: .relative(),
        height: 520.px,
        padding: .symmetric(horizontal: 24.px),
        overflow: .hidden,
        justifyContent: .center,
        alignItems: .center,
        textAlign: .center,
      ),
      css('.home-hero-img').styles(
        position: .absolute(top: .zero, left: .zero),
        width: 100.percent,
        height: 100.percent,
        raw: {'object-fit': 'cover'},
      ),
      // The scrim is what makes white text legible, and its floor is set for
      // the worst case rather than for the photo that happens to be uploaded
      // today: against a blown-out white region, alpha .70 still clears
      // 4.73:1 and .88 clears 8.6:1. The mockup's .15 top stop measured
      // 1.31:1 on white — fine over its flat grey placeholder, unreadable
      // over a real photo. Since the image is editor-replaceable, the
      // guarantee has to hold for any photo, not just this one.
      css('.home-hero-scrim').styles(
        position: .absolute(top: .zero, left: .zero),
        width: 100.percent,
        height: 100.percent,
        raw: {
          'background-image':
              'linear-gradient(180deg, rgba(20, 60, 85, 0.70), rgba(20, 60, 85, 0.88))',
        },
      ),
      css('.home-hero-copy').styles(
        position: .relative(),
        maxWidth: 760.px,
        color: Colors.white,
      ),
      css('.home-hero-copy h1').styles(
        margin: .only(bottom: 16.px),
        color: Colors.white,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 3.rem,
        fontWeight: .w600,
        letterSpacing: (-0.02).em,
        lineHeight: 1.1.em,
      ),
      css('.home-hero-copy p').styles(
        maxWidth: 560.px,
        margin: .only(bottom: 26.px, left: .auto, right: .auto),
        color: Colors.white,
        fontSize: 1.05.rem,
        lineHeight: 1.6.em,
      ),
      css('.hero-ctas').styles(
        display: .flex,
        flexWrap: .wrap,
        justifyContent: .center,
        gap: .all(14.px),
      ),
      // Both hero buttons sit on the scrim rather than on a page background,
      // so the secondary one is outlined in white instead of the coral it
      // uses elsewhere on the site.
      css('.btn-primary').styles(
        display: .inlineBlock,
        padding: .symmetric(vertical: 14.px, horizontal: 28.px),
        radius: .all(.circular(Radii.pill)),
        color: Colors.white,
        fontWeight: .w700,
        textDecoration: TextDecoration.none,
        backgroundColor: AppColors.coral,
      ),
      css('.btn-secondary').styles(
        display: .inlineBlock,
        padding: .symmetric(vertical: 14.px, horizontal: 28.px),
        border: .all(color: Colors.white, width: 2.px),
        radius: .all(.circular(Radii.pill)),
        color: Colors.white,
        fontWeight: .w700,
        textDecoration: TextDecoration.none,
      ),
      css('.btn-secondary:hover').styles(
        color: AppColors.navyDark,
        backgroundColor: Colors.white,
      ),

      // Section shell shared by both card rows. The band carries the tint
      // full-bleed while a separate inner element holds the max-width and
      // padding — the same split `.quick-links` uses. Putting both on one
      // element stops the tint at the container edge instead of the
      // viewport's, which is what the mockup shows.
      css('.home-section').styles(padding: .symmetric(vertical: 56.px)),
      css('.home-section-inner').styles(
        maxWidth: 1180.px,
        padding: .symmetric(horizontal: 24.px),
        margin: .symmetric(horizontal: .auto),
      ),
      css('.home-section-title').styles(
        margin: .only(bottom: 8.px),
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.9.rem,
        fontWeight: .w600,
        letterSpacing: (-0.01).em,
      ),
      css('.home-section-intro').styles(
        maxWidth: 600.px,
        margin: .only(top: .zero, bottom: 28.px),
        color: AppColors.mutedText,
        fontSize: 0.98.rem,
        lineHeight: 1.6.em,
      ),
      // auto-fit rather than three fixed tracks with breakpoint overrides:
      // the row lands on 3 columns at the full container, 2 in the 700-1000px
      // range and 1 below ~600px, with no thresholds to keep in sync. Three
      // fixed columns held all the way down to 375px and squeezed the titles
      // to two characters a line.
      css('.home-cards').styles(
        display: .grid,
        margin: .only(top: 24.px),
        gap: .all(22.px),
        raw: {'grid-template-columns': 'repeat(auto-fit, minmax(280px, 1fr))'},
      ),

      // One card, two rows. The tint is assigned by position via nth-child —
      // presentation, not content, the same call already made for the
      // service-section cards and the PA dues cards.
      css('.home-card', [
        css('&').styles(
          display: .block,
          radius: .all(.circular(Radii.lg)),
          overflow: .hidden,
          color: .inherit,
          textDecoration: TextDecoration.none,
        ),
        css('&:hover .home-card-cta').styles(textDecoration: const TextDecoration(line: .underline)),
        css('.home-card-photo').styles(
          display: .block,
          width: 100.percent,
          height: 170.px,
          raw: {'object-fit': 'cover'},
        ),
        css('.photo-placeholder').styles(height: 170.px),
        css('.home-card-body').styles(padding: .all(22.px)),
        css('.home-card-eyebrow').styles(
          color: AppColors.mutedTextLight,
          fontSize: 0.72.rem,
          fontWeight: .w800,
          textTransform: .upperCase,
          letterSpacing: 0.1.em,
        ),
        css('.home-card-title').styles(
          margin: .symmetric(vertical: 8.px),
          color: AppColors.navy,
          fontFamily: .list([headingFontFamily, FontFamilies.serif]),
          fontSize: 1.15.rem,
          fontWeight: .w600,
        ),
        css('.home-card-blurb').styles(
          margin: .only(bottom: 12.px),
          color: AppColors.mutedTextMid,
          fontSize: 0.92.rem,
          lineHeight: 1.5.em,
        ),
        css('.home-card-cta').styles(
          color: AppColors.coral,
          fontSize: 0.9.rem,
          fontWeight: .w700,
        ),
      ]),
      // Educational Programs keeps the three tints these age bands already
      // carry on the Programs hub, so the same programme reads the same
      // colour in both places.
      css('.programs-cards .home-card:nth-child(1)').styles(backgroundColor: AppColors.peach),
      css('.programs-cards .home-card:nth-child(2)').styles(backgroundColor: AppColors.sky),
      css('.programs-cards .home-card:nth-child(3)').styles(backgroundColor: AppColors.mint),
      // Services & Support gets the three tints added in Step 30, so the two
      // adjacent rows do not read as one six-card block.
      css('.services-cards .home-card:nth-child(1)').styles(backgroundColor: AppColors.lavender),
      css('.services-cards .home-card:nth-child(2)').styles(backgroundColor: AppColors.paleYellow),
      css('.services-cards .home-card:nth-child(3)').styles(backgroundColor: AppColors.paleBlue),
      // A fourth or later card cycles back rather than falling through to no
      // background, since the schema does not cap the array at three.
      css('.services-cards .home-card:nth-child(3n+4)').styles(backgroundColor: AppColors.lavender),

      // Section backgrounds. Both tints are existing tokens — the mockup's
      // #f9fcfd/#fff8ed are within 2/255 of offWhite/cream (the Step 22
      // finding), so no near-duplicate colours were added. The two rows run
      // the gradient in opposite directions so they read as a pair.
      css('.programs-section').styles(
        raw: {
          'background-image':
              'linear-gradient(160deg, ${AppColors.offWhite.value}, ${AppColors.cream.value})',
        },
      ),
      css('.services-section').styles(
        raw: {
          'background-image':
              'linear-gradient(160deg, ${AppColors.cream.value}, ${AppColors.offWhite.value})',
        },
      ),

      // News & events — two equal columns on one tinted band.
      css('.news-events-section').styles(
        raw: {
          'background-image':
              'linear-gradient(160deg, ${AppColors.offWhite.value}, ${AppColors.cream.value})',
        },
      ),
      css('.home-news-events').styles(
        display: .grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))]),
        ),
        gap: .all(32.px),
      ),
      css('.home-column-title').styles(
        margin: .only(top: .zero, bottom: 16.px),
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.4.rem,
        fontWeight: .w600,
      ),
      css('.home-empty').styles(color: AppColors.mutedTextMid, fontSize: 0.92.rem),
      css('.home-rows').styles(display: .grid, gap: .all(16.px)),

      // One row shape for both columns — the only difference is whether the
      // leading block is a photo or the coral date badge.
      css('.home-row', [
        css('&').styles(
          display: .flex,
          padding: .all(20.px),
          border: .all(color: AppColors.line, width: 1.px),
          radius: .all(.circular(Radii.md)),
          alignItems: .center,
          gap: .all(16.px),
          color: .inherit,
          textDecoration: TextDecoration.none,
          backgroundColor: Colors.white,
        ),
        css('&:hover').styles(border: .all(color: AppColors.lineDark, width: 1.px)),
        css('&:hover .home-row-title').styles(color: AppColors.coral),
      ]),
      css('.home-thumb').styles(
        width: 120.px,
        height: 92.px,
        radius: .all(.circular(Radii.sm)),
        overflow: .hidden,
        flex: Flex(grow: 0, shrink: 0),
        backgroundColor: AppColors.peach,
        raw: {'object-fit': 'cover'},
      ),
      css('.home-row-body').styles(minWidth: .zero),
      css('.home-row-title').styles(
        margin: .only(bottom: 4.px),
        color: AppColors.navy,
        fontSize: 1.rem,
        fontWeight: .w600,
        lineHeight: 1.3.em,
      ),
      css('.home-row-meta').styles(
        margin: .only(bottom: 6.px),
        color: AppColors.mutedTextLight,
        fontSize: 0.82.rem,
      ),
      css('.home-row-excerpt').styles(
        color: AppColors.mutedTextMid,
        fontSize: 0.88.rem,
        lineHeight: 1.5.em,
      ),
      css('.home-event-date').styles(
        display: .flex,
        width: 120.px,
        height: 92.px,
        radius: .all(.circular(Radii.sm)),
        flexDirection: .column,
        justifyContent: .center,
        alignItems: .center,
        flex: Flex(grow: 0, shrink: 0),
        color: Colors.white,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        backgroundColor: AppColors.coral,
      ),
      css('.home-event-month').styles(fontSize: 0.8.rem, textTransform: .upperCase),
      css('.home-event-day').styles(fontSize: 1.5.rem, fontWeight: .w700),

      // Current families band
      css('.current-families').styles(
        margin: .only(top: 28.px, left: 40.px, right: 40.px),
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.lg)),
        overflow: .hidden,
      ),
      css('.current-families-header').styles(
        display: .flex,
        padding: .symmetric(vertical: 13.px, horizontal: 20.px),
        justifyContent: .spaceBetween,
        alignItems: .center,
        backgroundColor: AppColors.sky,
      ),
      css('.current-families-title').styles(
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.125.rem,
        fontWeight: .w600,
      ),
      css('.current-families-title-accent').styles(color: AppColors.blue),
      css('.current-families-portal').styles(
        color: AppColors.mutedTextLight,
        fontSize: 0.8125.rem,
      ),
      css('.current-families-body').styles(display: .flex),
      css('.current-families-feature', [
        css('&').styles(
          display: .flex,
          padding: .symmetric(vertical: 18.px, horizontal: 20.px),
          border: .only(
            right: .solid(color: AppColors.line, width: 1.px),
          ),
          alignItems: .center,
          gap: .all(14.px),
          flex: Flex(grow: 1.2),
        ),
        css('.current-families-icon').styles(
          display: .flex,
          width: 60.px,
          height: 60.px,
          padding: .all(12.px),
          radius: .all(.circular(Radii.sm)),
          justifyContent: .center,
          alignItems: .center,
          flex: Flex(grow: 0, shrink: 0),
          fontSize: 1.375.rem,
          raw: {
            'background-image':
                'repeating-linear-gradient(135deg, ${AppColors.peach.value}, ${AppColors.peach.value} 6px, ${AppColors.peachDark.value} 6px, ${AppColors.peachDark.value} 12px)',
          },
        ),
        // The tile held a 1.375rem emoji, which sized itself; an SVG has no
        // intrinsic size, so it gets one here. Navy clears 11:1 on both the
        // peach and mint tiles.
        css('.current-families-icon svg').styles(
          width: 26.px,
          height: 26.px,
          color: AppColors.navy,
        ),
        css('.current-families-feature-title').styles(
          color: AppColors.navy,
          fontSize: 1.rem,
          fontWeight: .w600,
        ),
        css('.current-families-feature-desc').styles(
          margin: .only(top: 2.px),
          color: AppColors.mutedTextLight,
          fontSize: 0.8125.rem,
          lineHeight: 1.45.em,
        ),
        css('.current-families-feature-cta').styles(
          margin: .only(top: 6.px),
          color: AppColors.coral,
          fontSize: 0.8125.rem,
          fontWeight: .w700,
        ),
      ]),
      // Second feature (Important Documents) gets a mint icon tile instead
      // of peach — matches the reference's per-icon color differentiation
      // without needing a modifier class on the component.
      css('.current-families-feature:nth-child(2) .current-families-icon').styles(
        raw: {
          'background-image':
              'repeating-linear-gradient(135deg, ${AppColors.mint.value}, ${AppColors.mint.value} 6px, ${AppColors.mintDark.value} 6px, ${AppColors.mintDark.value} 12px)',
        },
      ),
      css('.current-families-links').styles(
        display: .flex,
        padding: .symmetric(vertical: 18.px, horizontal: 20.px),
        flexDirection: .column,
        justifyContent: .center,
        gap: .all(8.px),
        flex: Flex(grow: 1),
        color: AppColors.coral,
        fontSize: 0.875.rem,
        fontWeight: .w700,
      ),

      // Donate band — full-bleed color band (no card border/margin), per
      // the reference's treatment of this section.
      css('.donate-band').styles(
        display: .flex,
        padding: .symmetric(vertical: 22.px, horizontal: 40.px),
        margin: .only(top: 24.px),
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: .all(18.px),
        backgroundColor: AppColors.yellow,
      ),
      css('.donate-band-title').styles(
        color: AppColors.navyDark,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.375.rem,
        fontWeight: .w600,
      ),
      css('.donate-band-subtitle').styles(
        margin: .only(top: 3.px),
        color: AppColors.navyDark,
        fontSize: 0.8125.rem,
      ),
      css('.donate-band-button').styles(
        padding: .symmetric(vertical: 13.px, horizontal: 26.px),
        radius: .all(.circular(Radii.pill)),
        color: Colors.white,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 1.rem,
        fontWeight: .w700,
        whiteSpace: .noWrap,
        backgroundColor: AppColors.navyDark,
      ),

      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        // Hero: the 520px desktop band is most of a phone screen, so it
        // shrinks and the display type comes down with it.
        css('.home-hero').styles(
          height: 420.px,
          padding: .symmetric(horizontal: 20.px),
        ),
        css('.home-hero-copy h1').styles(fontSize: 1.9.rem),
        css('.home-hero-copy p').styles(fontSize: 1.rem),
        css('.hero-ctas').styles(flexWrap: .wrap),
        css('.home-section').styles(padding: .symmetric(vertical: 36.px)),
        css('.home-section-inner').styles(padding: .symmetric(horizontal: 20.px)),
        css('.home-section-title').styles(fontSize: 1.6.rem),
        // Both columns stack; the grid, not a flex direction, controls this
        // now that the band is a two-track grid.
        css('.home-news-events').styles(
          gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
          gap: .all(28.px),
        ),
        css('.home-thumb').styles(width: 96.px, height: 74.px),
        css('.home-event-date').styles(width: 96.px, height: 74.px),
        css('.current-families').styles(
          margin: .only(top: 22.px, left: 20.px, right: 20.px),
        ),
        css('.current-families-header').styles(
          padding: .symmetric(vertical: 12.px, horizontal: 16.px),
          flexDirection: .column,
          alignItems: .start,
          gap: .all(6.px),
        ),
        css('.current-families-body').styles(flexDirection: .column),
        css('.current-families-feature').styles(
          border: .only(
            right: .none(),
            bottom: .solid(color: AppColors.line, width: 1.px),
          ),
        ),
        css('.donate-band').styles(
          padding: .symmetric(vertical: 20.px, horizontal: 20.px),
          flexDirection: .column,
          textAlign: .center,
        ),
      ]),
    ]),
  ];
}
