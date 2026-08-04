/// A `pa_event` document — a Parent Association meeting or event. Separate
/// document type from `event` (see CLAUDE.md Batch 10 correction note): no
/// images, and a `google_meet` link instead of a ticket link.
class PaEventItem {
  final String id;
  final String title;
  final String description;
  final String? meetingLink;
  final String location;
  final DateTime publishedDate;
  final DateTime eventDate;

  const PaEventItem({
    required this.id,
    required this.title,
    required this.description,
    this.meetingLink,
    required this.location,
    required this.publishedDate,
    required this.eventDate,
  });

  factory PaEventItem.fromJson(Map<String, dynamic> json) {
    return PaEventItem(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      meetingLink: json['google_meet'] as String?,
      location: json['location'] as String,
      publishedDate: DateTime.parse(json['published_date'] as String),
      eventDate: DateTime.parse(json['event_date'] as String),
    );
  }
}
