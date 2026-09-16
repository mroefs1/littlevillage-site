import 'page_content.dart';

/// One card in the homepage's "Services & Support" row.
///
/// [path] is a plain site path rather than a reference to the target
/// document. A reference would be safer against typos, but the pages these
/// cards point at do not share one route prefix — `page` documents live at
/// `/programs/...`, `/compliance`, `/careers` and so on — so a dereferenced
/// slug does not give a route. The schema validates the leading slash and
/// the field's own description says it must match a real page.
class ServiceCard {
  final String title;
  final String eyebrow;
  final String blurb;
  final String path;

  /// Optional — the card falls back to a striped [PhotoPlaceholder] until an
  /// editor uploads a photo, so the row never renders an empty box.
  final PageImage? image;

  const ServiceCard({
    required this.title,
    required this.eyebrow,
    required this.blurb,
    required this.path,
    this.image,
  });

  factory ServiceCard.fromJson(Map<String, dynamic> json) {
    return ServiceCard(
      title: json['title'] as String,
      eyebrow: json['eyebrow'] as String,
      blurb: json['blurb'] as String,
      path: json['path'] as String,
      image: PageImage.fromJsonOrNull(json['image'] as Map<String, dynamic>?),
    );
  }
}

/// The `homepage` singleton — the hero's photo and copy, plus the editorial
/// content of the two card sections that is not already carried by the
/// `program` documents.
///
/// Every field is nullable and [Homepage.fromJson] tolerates a missing
/// document entirely, so an unpublished or half-filled singleton degrades to
/// the hard-coded fallbacks in `home.dart` rather than failing the static
/// build. The homepage is the one route where a build failure is most
/// costly, and a singleton is exactly the kind of document someone can
/// unpublish by accident.
class Homepage {
  final PageImage? heroImage;
  final String? heroHeadline;
  final String? heroSubhead;
  final String? heroPrimaryCtaLabel;
  final String? heroSecondaryCtaLabel;
  final String? programsIntro;
  final List<ServiceCard> serviceCards;

  const Homepage({
    this.heroImage,
    this.heroHeadline,
    this.heroSubhead,
    this.heroPrimaryCtaLabel,
    this.heroSecondaryCtaLabel,
    this.programsIntro,
    this.serviceCards = const [],
  });

  factory Homepage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Homepage();
    return Homepage(
      heroImage: PageImage.fromJsonOrNull(json['heroImage'] as Map<String, dynamic>?),
      heroHeadline: json['heroHeadline'] as String?,
      heroSubhead: json['heroSubhead'] as String?,
      heroPrimaryCtaLabel: json['heroPrimaryCtaLabel'] as String?,
      heroSecondaryCtaLabel: json['heroSecondaryCtaLabel'] as String?,
      programsIntro: json['programsIntro'] as String?,
      serviceCards: (json['serviceCards'] as List<dynamic>? ?? const [])
          .map((card) => ServiceCard.fromJson(card as Map<String, dynamic>))
          .toList(),
    );
  }
}
