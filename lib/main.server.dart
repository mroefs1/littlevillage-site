/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

// Server-specific Jaspr import.
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

// Imports the [App] component.
import 'app.dart';
import 'constants/seo.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [Document] renders the root document structure (<html>, <head> and <body>).
  // Global styles are defined via `@css`-annotated getters (see lib/constants/theme.dart)
  // rather than passed here, so they're picked up automatically across the project.
  // `meta`/`head` here are site-wide fallbacks — individual pages override them
  // via the `SeoMeta` component (lib/components/seo_meta.dart).
  runApp(
    Document(
      title: siteName,
      meta: {'description': defaultMetaDescription},
      head: [const link(href: '/favicon.ico', rel: 'icon')],
      body: App(),
    ),
  );
}
