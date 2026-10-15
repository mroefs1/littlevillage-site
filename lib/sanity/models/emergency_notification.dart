/// An `emergency_notification` document - a school closure, a snow day, a
/// building issue. Shared with the Flutter app, which shows the same document
/// as a banner on its home screen.
///
/// Nullable where the schema is required, same as `SplashPromo`: a
/// half-filled document must not be able to crash the static build.
/// [shouldRender] is what decides whether anything gets emitted.
class EmergencyNotification {
  final String title;
  final String text;
  final DateTime? expiration;
  final String? moreInfoLink;

  const EmergencyNotification({
    required this.title,
    required this.text,
    this.expiration,
    this.moreInfoLink,
  });

  factory EmergencyNotification.fromJson(Map<String, dynamic> json) {
    final expiration = json['expiration'];
    return EmergencyNotification(
      title: (json['title'] as String? ?? '').trim(),
      text: (json['text'] as String? ?? '').trim(),
      expiration: expiration is String ? DateTime.tryParse(expiration) : null,
      moreInfoLink: json['more_info_link'] as String?,
    );
  }

  /// Something to say, and an expiration still ahead of [now]. The query
  /// already filters on expiry, but against Sanity's clock at query time; this
  /// keeps the build honest if the two disagree.
  bool shouldRender(DateTime now) =>
      (title.isNotEmpty || text.isNotEmpty) && expiration != null && expiration!.isAfter(now);
}
