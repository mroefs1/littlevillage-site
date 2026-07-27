import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/seo.dart';

// Per-page <head> metadata: title, description, canonical link, and Open
// Graph tags. Uses `Document.head`, which teleports its children into the
// document's <head> regardless of where in the tree it's mounted. Because
// page components are mounted deeper than the router's own bare
// `Document.head(title: route.title)` call (see jaspr_router's `router.dart`),
// this overrides that title rather than conflicting with it.
class SeoMeta extends StatelessComponent {
  const SeoMeta({
    required this.title,
    required this.description,
    required this.path,
    this.image,
    this.type = 'website',
    super.key,
  });

  final String title;
  final String description;
  final String path;
  final String? image;
  final String type;

  @override
  Component build(BuildContext context) {
    final url = '$siteBaseUrl$path';
    final imageUrl = switch (image) {
      null => null,
      final img when img.startsWith('http') => img,
      final img => '$siteBaseUrl$img',
    };

    return Document.head(
      title: title,
      meta: {'description': description},
      children: [
        link(href: url, rel: 'canonical'),
        meta(attributes: {'property': 'og:site_name', 'content': siteName}),
        meta(attributes: {'property': 'og:title', 'content': title}),
        meta(attributes: {'property': 'og:description', 'content': description}),
        meta(attributes: {'property': 'og:type', 'content': type}),
        meta(attributes: {'property': 'og:url', 'content': url}),
        if (imageUrl != null) meta(attributes: {'property': 'og:image', 'content': imageUrl}),
      ],
    );
  }
}
