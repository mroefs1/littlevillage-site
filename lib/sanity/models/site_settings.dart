class NavLink {
  final String label;
  final String url;
  final List<NavLink> children;

  const NavLink({required this.label, required this.url, this.children = const []});

  factory NavLink.fromJson(Map<String, dynamic> json) {
    return NavLink(
      label: json['label'] as String,
      url: json['url'] as String,
      children: (json['children'] as List<dynamic>? ?? const [])
          .map((child) => NavLink.fromJson(child as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FooterLink {
  final String label;
  final String url;

  const FooterLink({required this.label, required this.url});

  factory FooterLink.fromJson(Map<String, dynamic> json) {
    return FooterLink(label: json['label'] as String, url: json['url'] as String);
  }
}

class SocialLink {
  final String platform;
  final String url;

  const SocialLink({required this.platform, required this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(platform: json['platform'] as String, url: json['url'] as String);
  }
}

/// One photo in `siteSettings.gallery`. Renamed from `HeroGalleryImage` in
/// Step 30, when the homepage hero became a single still photo and the
/// carousel came off that page — the photos are kept as a general pool for
/// reuse when the carousel is mounted elsewhere.
class GalleryImage {
  final String url;
  final String alt;

  const GalleryImage({required this.url, required this.alt});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(url: json['url'] as String, alt: json['alt'] as String);
  }
}

class SiteSettings {
  final List<NavLink> navigation;
  final List<FooterLink> footerLinks;
  final List<SocialLink> socialLinks;
  final String? phone;
  final String? email;
  final List<GalleryImage> gallery;
  final String? donateUrl;

  const SiteSettings({
    this.navigation = const [],
    this.footerLinks = const [],
    this.socialLinks = const [],
    this.phone,
    this.email,
    this.gallery = const [],
    this.donateUrl,
  });

  factory SiteSettings.fromJson(Map<String, dynamic> json) {
    return SiteSettings(
      navigation: (json['navigation'] as List<dynamic>? ?? const [])
          .map((item) => NavLink.fromJson(item as Map<String, dynamic>))
          .toList(),
      footerLinks: (json['footerLinks'] as List<dynamic>? ?? const [])
          .map((item) => FooterLink.fromJson(item as Map<String, dynamic>))
          .toList(),
      socialLinks: (json['socialLinks'] as List<dynamic>? ?? const [])
          .map((item) => SocialLink.fromJson(item as Map<String, dynamic>))
          .toList(),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      gallery: (json['gallery'] as List<dynamic>? ?? const [])
          .map((item) => GalleryImage.fromJson(item as Map<String, dynamic>))
          .toList(),
      donateUrl: json['donateUrl'] as String?,
    );
  }
}
