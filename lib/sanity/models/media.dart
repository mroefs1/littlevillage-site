/// One link on a press item — either an external article (`href`) or an
/// uploaded PDF/scan (`fileUrl`), never both. The schema enforces exactly one;
/// [url] resolves whichever is set.
class PressLink {
  final String label;
  final String? href;
  final String? fileUrl;

  const PressLink({required this.label, this.href, this.fileUrl});

  factory PressLink.fromJson(Map<String, dynamic> json) {
    return PressLink(
      label: json['label'] as String? ?? 'View',
      href: json['href'] as String?,
      fileUrl: json['fileUrl'] as String?,
    );
  }

  String? get url => href ?? fileUrl;
}

/// A press mention for the Media › In The News page.
class PressItem {
  final String title;
  final String? publication;
  final String? date;
  final String? dateLabel;
  final String? thumbnailUrl;
  final String? thumbnailAlt;
  final List<PressLink> links;

  const PressItem({
    required this.title,
    this.publication,
    this.date,
    this.dateLabel,
    this.thumbnailUrl,
    this.thumbnailAlt,
    this.links = const [],
  });

  factory PressItem.fromJson(Map<String, dynamic> json) {
    return PressItem(
      title: json['title'] as String? ?? '',
      publication: json['publication'] as String?,
      date: json['date'] as String?,
      dateLabel: json['dateLabel'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      thumbnailAlt: json['thumbnailAlt'] as String?,
      links: (json['links'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(PressLink.fromJson)
          .toList(),
    );
  }
}

/// A video for the Media › Videos page. The embed URL is derived from
/// [youtubeUrl] at render time by `VideoEmbed`.
class VideoItem {
  final String title;
  final String youtubeUrl;
  final String? description;

  const VideoItem({required this.title, required this.youtubeUrl, this.description});

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      title: json['title'] as String? ?? '',
      youtubeUrl: json['youtubeUrl'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}
