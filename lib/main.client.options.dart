// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:littlevillage_site/components/accessibility_panel.dart'
    deferred as _accessibility_panel;
import 'package:littlevillage_site/components/contact_form.dart'
    deferred as _contact_form;
import 'package:littlevillage_site/components/faq_accordion.dart'
    deferred as _faq_accordion;
import 'package:littlevillage_site/components/language_switcher.dart'
    deferred as _language_switcher;
import 'package:littlevillage_site/components/mobile_nav.dart'
    deferred as _mobile_nav;
import 'package:littlevillage_site/components/news_events_filter.dart'
    deferred as _news_events_filter;
import 'package:littlevillage_site/components/splash_screen.dart'
    deferred as _splash_screen;

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
    'accessibility_panel': ClientLoader(
      (p) => _accessibility_panel.AccessibilityPanel(),
      loader: _accessibility_panel.loadLibrary,
    ),
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
    'language_switcher': ClientLoader(
      (p) => _language_switcher.LanguageSwitcher(),
      loader: _language_switcher.loadLibrary,
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
    'splash_screen': ClientLoader(
      (p) => _splash_screen.SplashScreen(
        imageUrl: p['imageUrl'] as String,
        imageAlt: p['imageAlt'] as String,
        headline: p['headline'] as String,
        dateLine: p['dateLine'] as String,
        promoKey: p['promoKey'] as String,
        eventLocation: p['eventLocation'] as String?,
        ctaLabel: p['ctaLabel'] as String?,
        ctaHref: p['ctaHref'] as String?,
        detailHref: p['detailHref'] as String?,
      ),
      loader: _splash_screen.loadLibrary,
    ),
  },
);
