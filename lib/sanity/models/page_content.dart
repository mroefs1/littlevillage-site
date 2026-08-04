import 'portable_text.dart';

/// One image in a `page` document's `images` array, e.g. a single step
/// photo in the Admissions journey.
class PageImage {
  final String url;
  final String alt;

  const PageImage({required this.url, required this.alt});

  factory PageImage.fromJson(Map<String, dynamic> json) {
    return PageImage(url: json['url'] as String, alt: json['alt'] as String);
  }
}

/// A `page` document (About/Mission/History/Facilities-type content).
class PageContent {
  final String title;
  final String slug;
  final String? heroImageUrl;
  final List<PageImage> images;
  final PortableText body;

  const PageContent({
    required this.title,
    required this.slug,
    this.heroImageUrl,
    this.images = const [],
    required this.body,
  });

  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
      title: json['title'] as String,
      slug: json['slug'] as String,
      heroImageUrl: json['heroImageUrl'] as String?,
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((item) => PageImage.fromJson(item as Map<String, dynamic>))
          .toList(),
      body: PortableText.fromJson(json['body'] as List<dynamic>?),
    );
  }
}
