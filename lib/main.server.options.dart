// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:littlevillage_site/components/content_page.dart'
    as _content_page;
import 'package:littlevillage_site/components/counter.dart' as _counter;
import 'package:littlevillage_site/components/footer.dart' as _footer;
import 'package:littlevillage_site/components/header.dart' as _header;
import 'package:littlevillage_site/constants/theme.dart' as _theme;
import 'package:littlevillage_site/pages/home.dart' as _home;
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
  clients: {_home.Home: ClientTarget<_home.Home>('home')},
  styles: () => [
    ..._theme.globalStyles,
    ..._app.App.styles,
    ..._content_page.ContentPage.styles,
    ..._counter.CounterState.styles,
    ..._footer.Footer.styles,
    ..._header.Header.styles,
    ..._home.HomeState.styles,
  ],
);
