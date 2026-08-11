// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:littlevillage_site/components/contact_form.dart'
    deferred as _contact_form;
import 'package:littlevillage_site/components/faq_accordion.dart'
    deferred as _faq_accordion;
import 'package:littlevillage_site/components/hero_gallery.dart'
    deferred as _hero_gallery;
import 'package:littlevillage_site/components/mobile_nav.dart'
    deferred as _mobile_nav;
import 'package:littlevillage_site/components/news_events_filter.dart'
    deferred as _news_events_filter;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'contact_form': ClientLoader(
      (p) => _contact_form.ContactForm(),
      loader: _contact_form.loadLibrary,
    ),
    'faq_accordion': ClientLoader(
      (p) => _faq_accordion.FaqAccordion(
        items: (p['items'] as List<Object?>)
            .map((i) => (i as Map<String, Object?>).cast<String, String>())
            .toList(),
        initialOpenIndex: p['initialOpenIndex'] as int?,
      ),
      loader: _faq_accordion.loadLibrary,
    ),
    'hero_gallery': ClientLoader(
      (p) => _hero_gallery.HeroGallery(
        images: (p['images'] as List<Object?>)
            .map((i) => (i as Map<String, Object?>).cast<String, String>())
            .toList(),
      ),
      loader: _hero_gallery.loadLibrary,
    ),
    'mobile_nav': ClientLoader(
      (p) => _mobile_nav.MobileNav(
        activePath: p['activePath'] as String,
        items: (p['items'] as List<Object?>)
            .map((i) => (i as Map<String, Object?>))
            .toList(),
      ),
      loader: _mobile_nav.loadLibrary,
    ),
    'news_events_filter': ClientLoader(
      (p) => _news_events_filter.NewsEventsFilter(
        newsItems: (p['newsItems'] as List<Object?>)
            .map((i) => (i as Map<String, Object?>).cast<String, String?>())
            .toList(),
        eventItems: (p['eventItems'] as List<Object?>)
            .map((i) => (i as Map<String, Object?>).cast<String, String?>())
            .toList(),
      ),
      loader: _news_events_filter.loadLibrary,
    ),
  },
);
