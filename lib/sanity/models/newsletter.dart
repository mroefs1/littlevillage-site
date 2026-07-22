/// A `newsletter` document — a downloadable PDF with a title and date.
class Newsletter {
  final String id;
  final String title;
  final DateTime publishedDate;
  final String? fileUrl;

  const Newsletter({
    required this.id,
    required this.title,
    required this.publishedDate,
    this.fileUrl,
  });

  factory Newsletter.fromJson(Map<String, dynamic> json) {
    return Newsletter(
      id: json['_id'] as String,
      title: json['title'] as String,
      publishedDate: DateTime.parse(json['published_date'] as String),
      fileUrl: json['fileUrl'] as String?,
    );
  }
}
