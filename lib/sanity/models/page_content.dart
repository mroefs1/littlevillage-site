import 'portable_text.dart';

/// A `page` document (About/Mission/History/Facilities-type content).
class PageContent {
  final String title;
  final String slug;
  final String? heroImageUrl;
  final PortableText body;

  const PageContent({
    required this.title,
    required this.slug,
    this.heroImageUrl,
    required this.body,
  });

  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
      title: json['title'] as String,
      slug: json['slug'] as String,
      heroImageUrl: json['heroImageUrl'] as String?,
      body: PortableText.fromJson(json['body'] as List<dynamic>?),
    );
  }
}
