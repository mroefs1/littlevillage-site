// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:littlevillage_site/components/collection_card.dart'
    as _collection_card;
import 'package:littlevillage_site/components/content_page.dart'
    as _content_page;
import 'package:littlevillage_site/components/cta_band.dart' as _cta_band;
import 'package:littlevillage_site/components/faq_accordion.dart'
    as _faq_accordion;
import 'package:littlevillage_site/components/footer.dart' as _footer;
import 'package:littlevillage_site/components/header.dart' as _header;
import 'package:littlevillage_site/components/hero_gallery.dart'
    as _hero_gallery;
import 'package:littlevillage_site/components/mobile_nav.dart' as _mobile_nav;
import 'package:littlevillage_site/components/news_events_filter.dart'
    as _news_events_filter;
import 'package:littlevillage_site/components/photo_placeholder.dart'
    as _photo_placeholder;
import 'package:littlevillage_site/components/pill_list.dart' as _pill_list;
import 'package:littlevillage_site/components/portable_text_view.dart'
    as _portable_text_view;
import 'package:littlevillage_site/constants/theme.dart' as _theme;
import 'package:littlevillage_site/pages/about.dart' as _about;
import 'package:littlevillage_site/pages/admissions.dart' as _admissions;
import 'package:littlevillage_site/pages/contact.dart' as _contact;
import 'package:littlevillage_site/pages/current_families.dart'
    as _current_families;
import 'package:littlevillage_site/pages/event_detail.dart' as _event_detail;
import 'package:littlevillage_site/pages/home.dart' as _home;
import 'package:littlevillage_site/pages/not_found.dart' as _not_found;
import 'package:littlevillage_site/pages/parent_association.dart'
    as _parent_association;
import 'package:littlevillage_site/pages/program_detail.dart'
    as _program_detail;
import 'package:littlevillage_site/pages/programs.dart' as _programs;
import 'package:littlevillage_site/pages/support_us.dart' as _support_us;
import 'package:littlevillage_site/app.dart' as _app;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _faq_accordion.FaqAccordion: ClientTarget<_faq_accordion.FaqAccordion>(
      'faq_accordion',
      params: __faq_accordionFaqAccordion,
    ),
    _hero_gallery.HeroGallery: ClientTarget<_hero_gallery.HeroGallery>(
      'hero_gallery',
      params: __hero_galleryHeroGallery,
    ),
    _mobile_nav.MobileNav: ClientTarget<_mobile_nav.MobileNav>(
      'mobile_nav',
      params: __mobile_navMobileNav,
    ),
    _news_events_filter.NewsEventsFilter:
        ClientTarget<_news_events_filter.NewsEventsFilter>(
          'news_events_filter',
          params: __news_events_filterNewsEventsFilter,
        ),
  },
  styles: () => [
    ..._theme.globalStyles,
    ..._app.App.styles,
    ..._collection_card.CollectionCard.styles,
    ..._content_page.ContentPage.styles,
    ..._cta_band.CtaBand.styles,
    ..._faq_accordion.FaqAccordion.styles,
    ..._footer.Footer.styles,
    ..._header.Header.styles,
    ..._hero_gallery.HeroGallery.styles,
    ..._mobile_nav.MobileNav.styles,
    ..._news_events_filter.NewsEventsFilter.styles,
    ..._photo_placeholder.PhotoPlaceholder.styles,
    ..._pill_list.PillList.styles,
    ..._portable_text_view.PortableTextView.styles,
    ..._about.About.styles,
    ..._admissions.Admissions.styles,
    ..._contact.Contact.styles,
    ..._current_families.CurrentFamilies.styles,
    ..._event_detail.EventDetail.styles,
    ..._home.Home.styles,
    ..._not_found.NotFound.styles,
    ..._parent_association.ParentAssociation.styles,
    ..._program_detail.ProgramDetail.styles,
    ..._programs.Programs.styles,
    ..._support_us.SupportUs.styles,
  ],
);

Map<String, Object?> __faq_accordionFaqAccordion(
  _faq_accordion.FaqAccordion c,
) => {'items': c.items, 'initialOpenIndex': c.initialOpenIndex};
Map<String, Object?> __hero_galleryHeroGallery(_hero_gallery.HeroGallery c) => {
  'images': c.images,
};
Map<String, Object?> __mobile_navMobileNav(_mobile_nav.MobileNav c) => {
  'activePath': c.activePath,
  'items': c.items,
};
Map<String, Object?> __news_events_filterNewsEventsFilter(
  _news_events_filter.NewsEventsFilter c,
) => {'newsItems': c.newsItems, 'eventItems': c.eventItems};
