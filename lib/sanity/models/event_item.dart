/// An `event` document. Named `EventItem` (not `Event`) to avoid colliding
/// with `dart:html`/`package:web`'s `Event` type.
class EventItem {
  final String id;
  final String title;
  final String? slug;
  final DateTime publishedDate;
  final DateTime eventDate;
  final String location;
  final String? flyerUrl;
  final String? cardImageUrl;
  final String description;
  final String? ticketLink;
  final List<String> photoGalleryUrls;

  const EventItem({
    required this.id,
    required this.title,
    this.slug,
    required this.publishedDate,
    required this.eventDate,
    required this.location,
    this.flyerUrl,
    this.cardImageUrl,
    required this.description,
    this.ticketLink,
    this.photoGalleryUrls = const [],
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['_id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      publishedDate: DateTime.parse(json['published_date'] as String),
      eventDate: DateTime.parse(json['event_date'] as String),
      location: json['location'] as String,
      flyerUrl: json['flyerUrl'] as String?,
      cardImageUrl: json['cardImageUrl'] as String?,
      description: json['description'] as String,
      ticketLink: json['ticket_link'] as String?,
      photoGalleryUrls: (json['photoGalleryUrls'] as List<dynamic>? ?? const []).cast<String>(),
    );
  }
}
