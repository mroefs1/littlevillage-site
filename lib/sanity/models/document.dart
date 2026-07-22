/// A `doc` document — a downloadable PDF for current families (parent
/// handbooks, one-page calendars, district paperwork). Named
/// `ParentDocument` (not `Document`) to avoid colliding with
/// `dart:html`/`package:web`'s `Document` type.
class ParentDocument {
  final String id;
  final String title;
  final String? fileUrl;

  const ParentDocument({
    required this.id,
    required this.title,
    this.fileUrl,
  });

  factory ParentDocument.fromJson(Map<String, dynamic> json) {
    return ParentDocument(
      id: json['_id'] as String,
      title: json['title'] as String,
      fileUrl: json['fileUrl'] as String?,
    );
  }
}
