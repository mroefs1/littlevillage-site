// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:littlevillage_site/components/faq_accordion.dart'
    deferred as _faq_accordion;

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
    'faq_accordion': ClientLoader(
      (p) => _faq_accordion.FaqAccordion(
        items: (p['items'] as List<Object?>)
            .map((i) => (i as Map<String, Object?>).cast<String, String>())
            .toList(),
        initialOpenIndex: p['initialOpenIndex'] as int?,
      ),
      loader: _faq_accordion.loadLibrary,
    ),
  },
);
