import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../sanity/image_url.dart';
import '../sanity/models/page_content.dart';

// The main photo and the photo grid for a `page` document's images, used by
// `ContentPage` so any page picks both up by passing them through — no page
// needs markup or CSS of its own.
//
// Deliberately NOT the same component as the event detail page's
// `.evd-gallery-*` grid, despite the surface similarity. That one is a
// 4-up grid of square-cropped snapshots from an event; this is a 3-up grid
// of showcase photos of the school, shown at their real proportions. Same
// shape, different intent — folding them together would mean two config
// axes serving two designs, not shared code.

/// A page's single main image, shown full-width below the title.
class PageHeroImage extends StatelessComponent {
  final PageImage image;

  const PageHeroImage(this.image, {super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'page-hero', [
      img(
        src: sanityImageUrl(image.url, width: 1600),
        alt: image.alt,
        classes: 'page-hero-img',
        // Inline rather than in the stylesheet: this is per-image data from
        // Sanity, not a rule about the layout. Absent unless an editor set
        // a hotspot, leaving the CSS default (centred) in charge.
        styles: switch (image.objectPosition) {
          final position? => Styles(raw: {'object-position': position}),
          null => null,
        },
        attributes: {'loading': 'lazy', 'decoding': 'async'},
      ),
    ]);
  }
}

/// A page's additional images, as a plain grid.
class PageGallery extends StatelessComponent {
  final List<PageImage> images;

  const PageGallery(this.images, {super.key});

  @override
  Component build(BuildContext context) {
    if (images.isEmpty) return .fragment([]);
    return div(classes: 'page-gallery', [
      for (final image in images)
        img(
          // 3-up at 1440px is roughly 370px wide, so 760 covers it at 2x.
          src: sanityImageUrl(image.url, width: 760),
          alt: image.alt,
          classes: 'page-gallery-img',
          styles: switch (image.objectPosition) {
            final position? => Styles(raw: {'object-position': position}),
            null => null,
          },
          attributes: {'loading': 'lazy', 'decoding': 'async'},
        ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.page-hero').styles(margin: .only(top: 28.px)),
    css('.page-hero-img').styles(
      display: .block,
      width: 100.percent,
      // Caps how tall the main image can get, so it reads as a banner under
      // the title rather than a full screen of photo before any copy. This
      // is what makes every page's main image render at the same height
      // regardless of the shape of the file an editor uploaded.
      //
      // A cap rather than a wider aspect ratio on purpose: swapping the
      // ratio at a breakpoint would make the image jump height as the
      // viewport crosses it. Here the ratio only applies while the result
      // is under the cap (narrow viewports), and wide ones clamp flat to
      // 360px — so the height rises to the cap and stops, with no jump.
      maxHeight: 360.px,
      radius: .all(.circular(Radii.xxl)),
      // An editor-uploaded photo can be any shape, and letting a portrait
      // shot set its own height would push the whole page body below the
      // fold. `cover` crops to fill the box from the centre.
      raw: {'aspect-ratio': '16 / 9', 'object-fit': 'cover'},
    ),
    css('.page-gallery').styles(
      display: .grid,
      margin: .only(top: 28.px),
      gap: .all(16.px),
      raw: {'grid-template-columns': 'repeat(3, 1fr)'},
    ),
    css('.page-gallery-img').styles(
      display: .block,
      width: 100.percent,
      radius: .all(.circular(Radii.lg)),
      raw: {'aspect-ratio': '4 / 3', 'object-fit': 'cover'},
    ),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.page-gallery').styles(raw: {'grid-template-columns': 'repeat(2, 1fr)'}),
      css('.page-hero-img').styles(raw: {'aspect-ratio': '3 / 2'}),
    ]),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.small), [
      css('.page-gallery').styles(raw: {'grid-template-columns': '1fr'}),
    ]),
  ];
}
