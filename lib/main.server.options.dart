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
import 'package:littlevillage_site/components/photo_placeholder.dart'
    as _photo_placeholder;
import 'package:littlevillage_site/components/pill_list.dart' as _pill_list;
import 'package:littlevillage_site/components/portable_text_view.dart'
    as _portable_text_view;
import 'package:littlevillage_site/constants/theme.dart' as _theme;
import 'package:littlevillage_site/pages/about.dart' as _about;
import 'package:littlevillage_site/pages/admissions.dart' as _admissions;
import 'package:littlevillage_site/pages/home.dart' as _home;
import 'package:littlevillage_site/pages/program_detail.dart'
    as _program_detail;
import 'package:littlevillage_site/pages/programs.dart' as _programs;
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
    ..._photo_placeholder.PhotoPlaceholder.styles,
    ..._pill_list.PillList.styles,
    ..._portable_text_view.PortableTextView.styles,
    ..._about.About.styles,
    ..._admissions.Admissions.styles,
    ..._home.Home.styles,
    ..._program_detail.ProgramDetail.styles,
    ..._programs.Programs.styles,
  ],
);

Map<String, Object?> __faq_accordionFaqAccordion(
  _faq_accordion.FaqAccordion c,
) => {'items': c.items, 'initialOpenIndex': c.initialOpenIndex};
