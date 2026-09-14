import 'portable_text.dart';

/// One image on a `page` document — either the single `heroImage` or an
/// entry in the `images` array (e.g. a photo in the Facilities gallery, or
/// a single step photo in the Admissions journey).
class PageImage {
  final String url;
  final String alt;

  const PageImage({required this.url, required this.alt});

  /// `alt` is required by the schema, but defaults to an empty string here
  /// rather than throwing: a document published before the field existed
  /// (or edited past validation, which Sanity warns about but does not
  /// block) must not be able to crash the static build. An empty alt
  /// renders as a decorative image, which is the safer of the two wrong
  /// answers — a screen reader skips it instead of announcing a filename.
  factory PageImage.fromJson(Map<String, dynamic> json) {
    return PageImage(
      url: json['url'] as String,
      alt: json['alt'] as String? ?? '',
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
