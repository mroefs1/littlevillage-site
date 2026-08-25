import 'portable_text.dart';

/// One open position: a job title and the Indeed link for it. There is
/// deliberately no description/date/salary — the source carries none.
class CareerPosition {
  final String title;
  final String url;
  final String group;

  const CareerPosition({required this.title, required this.url, required this.group});

  factory CareerPosition.fromJson(Map<String, dynamic> json) {
    return CareerPosition(
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      group: json['group'] as String? ?? '',
    );
  }
}

/// The `careers` singleton — intro copy, the Indeed company-page link, and one
/// flat list of open positions. Positions carry their own `group` label rather
/// than being nested inside group objects, so an editor manages a single list;
/// the page groups them at render time.
class CareersInfo {
  final PortableText intro;
  final String? indeedUrl;
  final List<CareerPosition> positions;

  const CareersInfo({required this.intro, this.indeedUrl, this.positions = const []});

  factory CareersInfo.fromJson(Map<String, dynamic> json) {
    return CareersInfo(
      intro: PortableText.fromJson(json['intro'] as List<dynamic>?),
      indeedUrl: json['indeedUrl'] as String?,
      positions: (json['positions'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(CareerPosition.fromJson)
          .toList(),
    );
  }

  /// Positions in the order their groups first appear in the list, so the
  /// rendered grouping follows the editor's own ordering in Sanity rather than
  /// a hardcoded group sequence here.
  List<({String title, List<CareerPosition> positions})> get grouped {
    final order = <String>[];
    final byGroup = <String, List<CareerPosition>>{};
    for (final position in positions) {
      if (!byGroup.containsKey(position.group)) order.add(position.group);
      byGroup.putIfAbsent(position.group, () => []).add(position);
    }
    return [
      for (final group in order) (title: group, positions: byGroup[group]!),
    ];
  }
}
