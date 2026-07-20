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

class SiteSettings {
  final List<NavLink> navigation;
  final List<FooterLink> footerLinks;
  final List<SocialLink> socialLinks;
  final String? phone;
  final String? email;

  const SiteSettings({
    this.navigation = const [],
    this.footerLinks = const [],
    this.socialLinks = const [],
    this.phone,
    this.email,
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
    );
  }
}
