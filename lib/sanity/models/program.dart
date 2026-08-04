import 'portable_text.dart';

class Program {
  final String id;
  final String title;
  final String slug;
  final String category;
  final String? ageRange;
  final PortableText description;
  final String? imageUrl;
  final List<String> relatedProgramSlugs;

  const Program({
    required this.id,
    required this.title,
    required this.slug,
    required this.category,
    this.ageRange,
    required this.description,
    this.imageUrl,
    this.relatedProgramSlugs = const [],
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      category: json['category'] as String,
      ageRange: json['ageRange'] as String?,
      description: PortableText.fromJson(json['description'] as List<dynamic>?),
      imageUrl: json['imageUrl'] as String?,
      relatedProgramSlugs:
          (json['relatedProgramSlugs'] as List<dynamic>? ?? const []).cast<String>(),
    );
  }
}
