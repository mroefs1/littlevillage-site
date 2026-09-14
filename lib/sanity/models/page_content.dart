import 'portable_text.dart';

/// One image on a `page` document — either the single `heroImage` or an
/// entry in the `images` array (e.g. a photo in the Facilities gallery, or
/// a single step photo in the Admissions journey).
class PageImage {
  final String url;
  final String alt;

  /// The editor's focal point, as fractions of the image's width and height
  /// (Sanity's `hotspot`, which `page.heroImage`/`images[]` already enable
  /// but which nothing read until now). Null unless an editor has actually
  /// dragged the hotspot in the Studio.
  ///
  /// This matters because both slots crop to a fixed shape: the main image
  /// is capped at a banner height, and gallery tiles are 4:3. Cropping from
  /// the centre is the right default but the wrong answer often enough —
  /// the Facilities photo loses the top of the school's own sign — and the
  /// fix belongs with the image, not in the CSS, since it is a judgement
  /// about that photo rather than about the layout.
  final double? hotspotX;
  final double? hotspotY;

  const PageImage({
    required this.url,
    required this.alt,
    this.hotspotX,
    this.hotspotY,
  });

  /// The `object-position` value that keeps the focal point in frame, or
  /// null to leave the browser's centred default alone.
  String? get objectPosition {
    if (hotspotX == null || hotspotY == null) return null;
    String pct(double v) => (v.clamp(0, 1) * 100).toStringAsFixed(1);
    return '${pct(hotspotX!)}% ${pct(hotspotY!)}%';
  }

  /// `alt` is required by the schema, but defaults to an empty string here
  /// rather than throwing: a document published before the field existed
  /// (or edited past validation, which Sanity warns about but does not
  /// block) must not be able to crash the static build. An empty alt
  /// renders as a decorative image, which is the safer of the two wrong
  /// answers — a screen reader skips it instead of announcing a filename.
  factory PageImage.fromJson(Map<String, dynamic> json) {
    final hotspot = json['hotspot'] as Map<String, dynamic>?;
    return PageImage(
      url: json['url'] as String,
      alt: json['alt'] as String? ?? '',
      hotspotX: (hotspot?['x'] as num?)?.toDouble(),
      hotspotY: (hotspot?['y'] as num?)?.toDouble(),
    );
  }

  /// Returns null unless the projection actually resolved an asset URL, so
  /// callers can treat "no image set" and "image set but unresolvable" the
  /// same way.
  static PageImage? fromJsonOrNull(Map<String, dynamic>? json) {
    if (json == null || json['url'] is! String) return null;
    return PageImage.fromJson(json);
  }
}

/// A `page` document (About/Mission/History/Facilities-type content).
class PageContent {
  final String title;
  final String slug;
  final PageImage? heroImage;
  final List<PageImage> images;
  final PortableText body;

  const PageContent({
    required this.title,
    required this.slug,
    this.heroImage,
    this.images = const [],
    required this.body,
  });

  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
      title: json['title'] as String,
      slug: json['slug'] as String,
      heroImage: PageImage.fromJsonOrNull(json['heroImage'] as Map<String, dynamic>?),
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((item) => PageImage.fromJson(item as Map<String, dynamic>))
          .toList(),
      body: PortableText.fromJson(json['body'] as List<dynamic>?),
    );
  }
}
