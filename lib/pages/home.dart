import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/hero_gallery.dart';
import '../components/photo_placeholder.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/models/event_item.dart';
import '../sanity/models/news_post.dart';
import '../sanity/models/site_settings.dart';
import '../util/date_format.dart';

// Receives its news/events/heroGallery pre-fetched from [App] (already
// fetching the full lists for static routing purposes) rather than querying
// Sanity again — see app.dart.
class Home extends StatelessComponent {
  final List<NewsPost> newsPosts;
  final List<EventItem> events;
  final List<HeroGalleryImage> heroGallery;

  const Home({required this.newsPosts, required this.events, required this.heroGallery, super.key});

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
        _trustStrip(),
        _ageLocator(),
        _enrollmentTeaser(),
        _newsEvents(),
        _currentFamilies(),
        _donateBand(),
      ]),
    ]);
  }

  Component _hero() {
    return div(classes: 'hero', [
      div(classes: 'hero-copy', [
        div(classes: 'hero-eyebrow', [.text('For children birth–12 with developmental delays')]),
        h1([.text('A place where your child is understood — and so are you.')]),
        p([
          .text(
            "Specialized education and on-site therapy, fully publicly funded — at no cost to your family. "
            "We'll help you figure out the next step.",
          ),
        ]),
        div(classes: 'hero-ctas', [
          Link(to: '/contact', classes: 'btn-primary', child: .text('Request Information →')),
          Link(to: '/contact', classes: 'btn-secondary', child: .text('Schedule a Tour')),
        ]),
      ]),
      div(classes: 'hero-gallery-slot', [HeroGallery(images: heroGallery)]),
    ]);
  }

  static Component _trustStrip() {
    const stats = [
      (value: '\$0', label: 'cost to families'),
      (value: '50+', label: 'years serving Long Island'),
      (value: 'Birth–12', label: 'EI → Elementary'),
      (value: 'On-site', label: 'integrated therapy'),
    ];
    return div(classes: 'trust-strip', [
      for (final stat in stats)
        div(classes: 'trust-item', [
          div(classes: 'trust-value', [.text(stat.value)]),
          div(classes: 'trust-label', [.text(stat.label)]),
        ]),
    ]);
  }

  static Component _ageLocator() {
    const cards = [
      (
        age: 'Birth – 3 yrs',
        name: 'Early Intervention',
        desc: 'Home- & center-based support for your baby or toddler.',
        slug: 'early-intervention',
      ),
      (
        age: '3 – 5 yrs',
        name: 'Preschool Program',
        desc: 'Small classes pairing learning with therapy.',
        slug: 'preschool',
      ),
      (
        age: '5 – 12 yrs',
        name: 'Elementary School',
        desc: "A full school day built around each child's IEP.",
        slug: 'elementary',
      ),
    ];
    return div(classes: 'age-locator', [
      h2([.text("Not sure where to start? Begin with your child's age.")]),
      div(classes: 'age-cards', [
        for (final card in cards)
          Link(
            to: '/programs/${card.slug}',
            classes: 'age-card',
            child: .fragment([
              PhotoPlaceholder('photo', height: 84.px),
              div(classes: 'age-card-age', [.text(card.age)]),
              div(classes: 'age-card-name', [.text(card.name)]),
              div(classes: 'age-card-desc', [.text(card.desc)]),
              div(classes: 'age-card-cta', [.text('Learn more →')]),
            ]),
          ),
      ]),
    ]);
  }

  static Component _enrollmentTeaser() {
    const steps = [
      (n: '1', label: 'Reach out to us'),
      (n: '2', label: 'Evaluation (EI / CPSE)'),
      (n: '3', label: 'Visit & meet the team'),
      (n: '4', label: 'Placement & start'),
    ];
    return div(classes: 'enrollment-teaser', [
      div(classes: 'enrollment-teaser-header', [
        h2([.text('How enrollment works')]),
        Link(to: '/admissions', classes: 'enrollment-teaser-link', child: .text('Full admissions guide →')),
      ]),
      div(classes: 'enrollment-steps', [
        for (final step in steps)
          div(classes: 'enrollment-step', [
            div(classes: 'enrollment-step-badge', [.text(step.n)]),
            div(classes: 'enrollment-step-label', [.text(step.label)]),
          ]),
      ]),
    ]);
  }

  Component _newsEvents() {
    return div(classes: 'home-news-events', [
      div(classes: 'home-news', [
        h2([.text('Latest News')]),
        if (newsPosts.isEmpty)
          p([.text('No news posts yet.')])
        else
          div([for (final post in newsPosts) _newsRow(post)]),
      ]),
      div(classes: 'home-events', [
        h2([.text('Upcoming Events')]),
        if (events.isEmpty)
          p([.text('No upcoming events yet.')])
        else
          div([for (final event in events) _eventRow(event)]),
      ]),
    ]);
  }

  static Component _newsRow(NewsPost post) {
    final content = [
      div(classes: 'home-news-thumb', [if (post.heroImageUrl != null) img(src: post.heroImageUrl!, alt: 'News photo')]),
      div([
        div(classes: 'home-news-title', [.text(post.title)]),
        div(classes: 'home-news-date', [.text(formatDate(post.publishedDate))]),
      ]),
    ];
    if (post.slug != null) {
      return Link(to: '/news/${post.slug}', classes: 'home-news-row', child: .fragment(content));
    }
    if (post.link != null) {
      return a(href: post.link!, target: Target.blank, classes: 'home-news-row', content);
    }
    return div(classes: 'home-news-row', content);
  }

  static Component _eventRow(EventItem event) {
    final content = [
      div(classes: 'home-event-date', [
        div(classes: 'home-event-day', [.text('${event.eventDate.day}')]),
        div(classes: 'home-event-month', [.text(monthAbbr(event.eventDate))]),
      ]),
      div(classes: 'home-event-title', [.text(event.title)]),
    ];
    if (event.slug != null) {
      return Link(to: '/events/${event.slug}', classes: 'home-event-row', child: .fragment(content));
    }
    return div(classes: 'home-event-row', content);
  }

  static Component _currentFamilies() {
    return div(classes: 'current-families', [
      div(classes: 'current-families-header', [
        div(classes: 'current-families-title', [
          .text('Already part of Little Village? '),
          span(classes: 'current-families-title-accent', [.text('Welcome back.')]),
        ]),
        a(href: '#', classes: 'current-families-portal', [.text('Parent portal →')]),
      ]),
      div(classes: 'current-families-body', [
        Link(
          to: '/current-families',
          classes: 'current-families-feature',
          child: .fragment([
            div(classes: 'current-families-icon', [.text('📅')]),
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
            div(classes: 'current-families-icon', [.text('📄')]),
            div([
              div(classes: 'current-families-feature-title', [.text('Important Documents')]),
              div(classes: 'current-families-feature-desc', [.text('Forms, handbooks & lunch menus.')]),
              div(classes: 'current-families-feature-cta', [.text('Browse documents →')]),
            ]),
          ]),
        ),
        div(classes: 'current-families-links', [
          Link(to: '/current-families', child: .text('↳ Parent Association')),
          Link(to: '/current-families', child: .text('↳ Summer Recreation')),
          Link(to: '/current-families', child: .text('↳ Careers & staff portal')),
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
      a(href: '#', classes: 'donate-band-button', [.text('♥ Donate')]),
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

      // Hero
      css('.hero').styles(
        display: .grid,
        padding: .only(top: 34.px, left: 40.px, right: 40.px, bottom: 30.px),
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))])),
        gap: .all(26.px),
      ),
      css('.hero-eyebrow').styles(
        display: .inlineBlock,
        padding: .symmetric(vertical: 4.px, horizontal: 12.px),
        margin: .only(bottom: 14.px),
        radius: .all(.circular(20.px)),
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
        backgroundColor: AppColors.pillTint,
      ),
      css('.hero-copy h1').styles(fontSize: 40.px, lineHeight: 1.05.em),
      css('.hero-copy p').styles(
        maxWidth: 430.px,
        margin: .only(top: 14.px),
        color: AppColors.body,
        fontSize: 15.px,
        lineHeight: 1.55.em,
      ),
      css('.hero-ctas').styles(
        display: .flex,
        margin: .only(top: 22.px),
        gap: .all(12.px),
      ),
      // `position: relative` + the gallery filling it via absolute inset
      // keeps this slot out of both the row-height and column-width
      // intrinsic-sizing calculations — otherwise the photos' large
      // intrinsic pixel dimensions blow out the grid track sizes instead of
      // the slot simply stretching to match `.hero-copy`.
      css('.hero-gallery-slot').styles(position: .relative(), minWidth: .zero),

      // Buttons (shared by hero, donate band, CTA bands added in later batches)
      css('.btn-primary').styles(
        padding: .symmetric(vertical: 13.px, horizontal: 22.px),
        radius: .all(.circular(9.px)),
        shadow: BoxShadow(offsetX: 2.px, offsetY: 2.px, blur: 0.px, color: .rgba(47, 90, 168, 0.25)),
        color: Colors.white,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 17.px,
        fontWeight: .w700,
        backgroundColor: AppColors.primary,
      ),
      css('.btn-secondary').styles(
        padding: .symmetric(vertical: 11.px, horizontal: 20.px),
        border: .all(color: AppColors.primary, width: 2.px),
        radius: .all(.circular(9.px)),
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 17.px,
        fontWeight: .w700,
        backgroundColor: Colors.white,
      ),

      // Trust strip
      css('.trust-strip').styles(
        display: .flex,
        margin: .only(top: 8.px, left: 40.px, right: 40.px),
        border: .all(color: AppColors.borderLight, width: 2.px),
        radius: .all(.circular(10.px)),
        overflow: .hidden,
      ),
      css('.trust-item').styles(
        padding: .all(16.px),
        border: .only(
          right: .solid(color: AppColors.borderLight, width: 1.5.px),
        ),
        flex: Flex(grow: 1),
        textAlign: .center,
      ),
      css('.trust-item:last-child').styles(border: .none),
      css('.trust-value').styles(
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 24.px,
        fontWeight: .w700,
      ),
      css('.trust-label').styles(color: AppColors.body, fontSize: 12.px),

      // Age locator
      css('.age-locator').styles(
        padding: .only(top: 30.px, left: 40.px, right: 40.px, bottom: 8.px),
      ),
      css('.age-locator h2').styles(textAlign: .center, fontSize: 26.px),
      css('.age-cards').styles(
        display: .flex,
        margin: .only(top: 20.px),
        gap: .all(16.px),
      ),
      css('.age-card', [
        css('&').styles(
          display: .block,
          padding: .all(16.px),
          border: .all(color: AppColors.borderMedium, width: 2.px),
          radius: .all(.circular(10.px)),
          flex: Flex(grow: 1),
          backgroundColor: Colors.white,
        ),
        css('.photo-placeholder').styles(height: 84.px),
        css('.age-card-age').styles(
          margin: .only(top: 10.px),
          color: AppColors.primary,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 18.px,
          fontWeight: .w700,
        ),
        css('.age-card-name').styles(
          color: AppColors.ink,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 15.px,
        ),
        css('.age-card-desc').styles(
          margin: .only(top: 5.px),
          color: AppColors.body,
          fontSize: 13.px,
          lineHeight: 1.45.em,
        ),
        css('.age-card-cta').styles(
          margin: .only(top: 10.px),
          color: AppColors.primary,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 14.px,
          fontWeight: .w700,
        ),
      ]),

      // Enrollment teaser
      css('.enrollment-teaser').styles(
        padding: .symmetric(vertical: 20.px, horizontal: 22.px),
        margin: .only(top: 26.px, left: 40.px, right: 40.px),
        border: .all(color: AppColors.borderLight, width: 2.px),
        radius: .all(.circular(10.px)),
        backgroundColor: AppColors.shadedBg,
      ),
      css('.enrollment-teaser-header').styles(display: .flex, justifyContent: .spaceBetween, alignItems: .center),
      css('.enrollment-teaser-header h2').styles(fontSize: 22.px),
      css('.enrollment-teaser-link').styles(
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 15.px,
        fontWeight: .w700,
      ),
      css('.enrollment-steps').styles(
        display: .flex,
        margin: .only(top: 14.px),
        gap: .all(10.px),
      ),
      css('.enrollment-step').styles(flex: Flex(grow: 1), textAlign: .center),
      css('.enrollment-step-badge').styles(
        display: .flex,
        width: 30.px,
        height: 30.px,
        margin: .only(bottom: 6.px),
        radius: .all(.circular(15.px)),
        justifyContent: .center,
        alignItems: .center,
        color: Colors.white,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontWeight: .w700,
        backgroundColor: AppColors.primary,
        raw: {'margin-left': 'auto', 'margin-right': 'auto'},
      ),
      css('.enrollment-step-label').styles(color: AppColors.body, fontSize: 12.px),

      // News & events
      css('.home-news-events').styles(
        display: .flex,
        padding: .only(top: 30.px, left: 40.px, right: 40.px, bottom: 8.px),
        gap: .all(18.px),
      ),
      css('.home-news').styles(flex: Flex(grow: 1)),
      css('.home-events').styles(flex: Flex(grow: 1)),
      css('.home-news-events h2').styles(
        margin: .only(bottom: 10.px),
        fontSize: 22.px,
      ),
      css('.home-news-row', [
        css('&').styles(
          display: .flex,
          padding: .all(9.px),
          margin: .only(top: 10.px),
          border: .all(color: AppColors.borderLight, width: 2.px),
          radius: .all(.circular(8.px)),
          gap: .all(10.px),
        ),
        css('&:first-child').styles(margin: .zero),
      ]),
      css('.home-news-thumb').styles(
        display: .flex,
        width: 64.px,
        height: 48.px,
        radius: .all(.circular(5.px)),
        overflow: .hidden,
        flex: Flex(grow: 0, shrink: 0),
        backgroundColor: AppColors.borderLight,
      ),
      css('.home-news-thumb img').styles(
        width: 100.percent,
        height: 100.percent,
        raw: {'object-fit': 'cover'},
      ),
      css('.home-news-title').styles(
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 15.px,
        fontWeight: .w700,
        lineHeight: 1.1.em,
      ),
      css('.home-news-date').styles(color: AppColors.muted, fontSize: 12.px),
      css('.home-event-row', [
        css('&').styles(
          display: .flex,
          padding: .symmetric(vertical: 9.px, horizontal: 11.px),
          margin: .only(top: 10.px),
          border: .all(color: AppColors.borderLight, width: 2.px),
          radius: .all(.circular(8.px)),
          alignItems: .center,
          gap: .all(12.px),
        ),
        css('&:first-child').styles(margin: .zero),
      ]),
      css('.home-event-date').styles(flex: Flex(grow: 0, shrink: 0), textAlign: .center),
      css('.home-event-day').styles(
        color: AppColors.accent,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 20.px,
        fontWeight: .w700,
        lineHeight: 1.em,
      ),
      css('.home-event-month').styles(color: AppColors.muted, fontSize: 11.px),
      css('.home-event-title').styles(
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 15.px,
        fontWeight: .w700,
      ),

      // Current families band
      css('.current-families').styles(
        margin: .only(top: 28.px, left: 40.px, right: 40.px),
        border: .all(color: AppColors.borderMedium, width: 2.px),
        radius: .all(.circular(10.px)),
        overflow: .hidden,
      ),
      css('.current-families-header').styles(
        display: .flex,
        padding: .symmetric(vertical: 13.px, horizontal: 20.px),
        border: .only(
          bottom: .solid(color: AppColors.utilityBorder, width: 2.px),
        ),
        justifyContent: .spaceBetween,
        alignItems: .center,
        backgroundColor: AppColors.lightBlueTint,
      ),
      css('.current-families-title').styles(
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 20.px,
        fontWeight: .w700,
      ),
      css('.current-families-title-accent').styles(color: AppColors.primary),
      css('.current-families-portal').styles(
        color: AppColors.utilityText,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 13.px,
      ),
      css('.current-families-body').styles(display: .flex),
      css('.current-families-feature', [
        css('&').styles(
          display: .flex,
          padding: .symmetric(vertical: 18.px, horizontal: 20.px),
          border: .only(
            right: .solid(color: AppColors.borderLight, width: 1.5.px),
          ),
          alignItems: .center,
          gap: .all(14.px),
          flex: Flex(grow: 1.2),
        ),
        css('.current-families-icon').styles(
          display: .flex,
          width: 74.px,
          height: 74.px,
          padding: .all(12.px),
          border: .all(color: AppColors.placeholderBorder, width: 2.px, style: .dashed),
          radius: .all(.circular(8.px)),
          justifyContent: .center,
          alignItems: .center,
          flex: Flex(grow: 0, shrink: 0),
          fontSize: 22.px,
          raw: {
            'background-image':
                'repeating-linear-gradient(45deg, ${AppColors.borderLight.value}, ${AppColors.borderLight.value} 8px, ${AppColors.placeholderStripe.value} 8px, ${AppColors.placeholderStripe.value} 16px)',
          },
        ),
        css('.current-families-feature-title').styles(
          color: AppColors.ink,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 18.px,
          fontWeight: .w700,
        ),
        css('.current-families-feature-desc').styles(
          margin: .only(top: 2.px),
          color: AppColors.body,
          fontSize: 13.px,
          lineHeight: 1.45.em,
        ),
        css('.current-families-feature-cta').styles(
          margin: .only(top: 6.px),
          color: AppColors.primary,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 14.px,
          fontWeight: .w700,
        ),
      ]),
      css('.current-families-links').styles(
        display: .flex,
        padding: .symmetric(vertical: 18.px, horizontal: 20.px),
        flexDirection: .column,
        justifyContent: .center,
        gap: .all(8.px),
        flex: Flex(grow: 1),
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 15.px,
      ),

      // Donate band
      css('.donate-band').styles(
        display: .flex,
        padding: .symmetric(vertical: 22.px, horizontal: 24.px),
        margin: .only(top: 24.px, left: 40.px, right: 40.px),
        border: .all(color: AppColors.warmBorder, width: 2.px),
        radius: .all(.circular(10.px)),
        justifyContent: .spaceBetween,
        alignItems: .center,
        gap: .all(18.px),
        backgroundColor: AppColors.warmTint,
      ),
      css('.donate-band-title').styles(
        color: AppColors.warmText,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 22.px,
        fontWeight: .w700,
      ),
      css('.donate-band-subtitle').styles(
        margin: .only(top: 3.px),
        color: AppColors.warmMutedText,
        fontSize: 13.px,
      ),
      css('.donate-band-button').styles(
        padding: .symmetric(vertical: 13.px, horizontal: 26.px),
        radius: .all(.circular(9.px)),
        shadow: BoxShadow(offsetX: 2.px, offsetY: 2.px, blur: 0.px, color: .rgba(140, 80, 30, 0.25)),
        color: Colors.white,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 18.px,
        fontWeight: .w700,
        whiteSpace: .noWrap,
        backgroundColor: AppColors.accent,
      ),

      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('.hero').styles(
          padding: .only(top: 24.px, left: 20.px, right: 20.px, bottom: 24.px),
          gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
        ),
        css('.hero-copy h1').styles(fontSize: 28.px),
        css('.hero-ctas').styles(flexWrap: .wrap),
        css('.trust-strip').styles(
          margin: .only(top: 8.px, left: 20.px, right: 20.px),
          flexWrap: .wrap,
        ),
        css('.trust-item').styles(
          minWidth: 50.percent,
          border: .only(right: .none(), bottom: .solid(color: AppColors.borderLight, width: 1.5.px)),
        ),
        css('.age-locator').styles(padding: .only(top: 24.px, left: 20.px, right: 20.px, bottom: 8.px)),
        css('.age-cards').styles(flexDirection: .column),
        css('.enrollment-teaser').styles(
          padding: .symmetric(vertical: 18.px, horizontal: 18.px),
          margin: .only(top: 20.px, left: 20.px, right: 20.px),
        ),
        css('.enrollment-teaser-header').styles(flexDirection: .column, alignItems: .start, gap: .all(6.px)),
        css('.enrollment-steps').styles(flexWrap: .wrap),
        css('.enrollment-step').styles(minWidth: 50.percent),
        css('.home-news-events').styles(
          padding: .only(top: 24.px, left: 20.px, right: 20.px, bottom: 8.px),
          flexDirection: .column,
        ),
        css('.current-families').styles(margin: .only(top: 22.px, left: 20.px, right: 20.px)),
        css('.current-families-header').styles(
          padding: .symmetric(vertical: 12.px, horizontal: 16.px),
          flexDirection: .column,
          alignItems: .start,
          gap: .all(6.px),
        ),
        css('.current-families-body').styles(flexDirection: .column),
        css('.current-families-feature').styles(
          border: .only(right: .none(), bottom: .solid(color: AppColors.borderLight, width: 1.5.px)),
        ),
        css('.donate-band').styles(
          padding: .symmetric(vertical: 20.px, horizontal: 20.px),
          margin: .only(top: 20.px, left: 20.px, right: 20.px),
          flexDirection: .column,
          textAlign: .center,
        ),
      ]),
    ]),
  ];
}
