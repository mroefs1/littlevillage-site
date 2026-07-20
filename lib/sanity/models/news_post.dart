/// A `news` document. `slug` is optional in the schema (existing posts
/// predate the field), so it stays nullable here.
class NewsPost {
  final String id;
  final String title;
  final String? slug;
  final DateTime publishedDate;
  final String? heroImageUrl;
  final String body;
  final String? link;

  const NewsPost({
    required this.id,
    required this.title,
    this.slug,
    required this.publishedDate,
    this.heroImageUrl,
    required this.body,
    this.link,
  });

  factory NewsPost.fromJson(Map<String, dynamic> json) {
    return NewsPost(
      id: json['_id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      publishedDate: DateTime.parse(json['published_date'] as String),
      heroImageUrl: json['heroImageUrl'] as String?,
      body: json['body'] as String,
      link: json['link'] as String?,
    );
  }
}
