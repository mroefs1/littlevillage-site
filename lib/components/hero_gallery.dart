import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../sanity/models/site_settings.dart';

// Static filmstrip for now — clipped via `overflow-x: hidden` since there's
// no scrolling/auto-scroll yet (that's a later batch). Renders nothing (but
// still occupies its grid slot) when the gallery hasn't been populated in
// Sanity yet.
class HeroGallery extends StatelessComponent {
  final List<HeroGalleryImage> images;

  const HeroGallery({required this.images, super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'hero-gallery', [
      if (images.isNotEmpty)
        div(classes: 'hero-gallery-track', [
          for (final image in images)
            div(classes: 'hero-gallery-item', [
              img(src: image.url, alt: image.alt, classes: 'hero-gallery-photo'),
            ]),
        ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero-gallery').styles(
      display: .block,
      position: .absolute(top: .zero, left: .zero, right: .zero, bottom: .zero),
      radius: .all(.circular(14.px)),
      overflow: .hidden,
    ),
    css('.hero-gallery-track').styles(
      display: .flex,
      height: 100.percent,
      gap: .all(12.px),
    ),
    css('.hero-gallery-item').styles(
      display: .flex,
      height: 100.percent,
      flex: Flex(grow: 0, shrink: 0),
    ),
    css('.hero-gallery-photo').styles(
      display: .block,
      width: .auto,
      height: 100.percent,
      raw: {'object-fit': 'cover'},
    ),
  ];
}
