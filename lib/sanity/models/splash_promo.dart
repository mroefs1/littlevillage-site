/// The `splashPromo` singleton — the first-visit splash screen's configuration.
///
/// It points at an `event` rather than carrying its own copy of the details, so
/// the promoted event's title, date, venue, ticket link and artwork are entered
/// once. Everything here is either a switch or something the event cannot
/// answer: which of its two images to use, alt text for that image (the `event`
/// type has no `alt` sub-field, and it is shared with the Flutter app), and the
/// window to show it in.
///
/// Every field is nullable with a safe default, same as `SiteSettings` — a
/// half-filled document must not be able to crash the static build. The
/// `shouldRender` guard below is what decides whether anything gets emitted.
class SplashPromo {
  final bool enabled;
  final String? imageSource;
  final String imageAlt;
  final String? headlineOverride;
  final String? ctaLabelOverride;
  final DateTime? startDate;
  final DateTime? expiration;

  final String? eventTitle;
  final String? eventSlug;
  final DateTime? eventDate;
  final String? eventLocation;
  final String? ticketLink;
  final String? cardImageUrl;
  final String? flyerUrl;

  const SplashPromo({
    this.enabled = false,
    this.imageSource,
    this.imageAlt = '',
    this.headlineOverride,
    this.ctaLabelOverride,
    this.startDate,
    this.expiration,
    this.eventTitle,
    this.eventSlug,
    this.eventDate,
    this.eventLocation,
    this.ticketLink,
    this.cardImageUrl,
    this.flyerUrl,
  });

  factory SplashPromo.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as Map<String, dynamic>? ?? const {};
    return SplashPromo(
      enabled: json['enabled'] as bool? ?? false,
      imageSource: json['imageSource'] as String?,
      imageAlt: json['imageAlt'] as String? ?? '',
      headlineOverride: json['headline'] as String?,
      ctaLabelOverride: json['ctaLabel'] as String?,
      startDate: _parseDate(json['startDate']),
      expiration: _parseDate(json['expiration']),
      eventTitle: event['title'] as String?,
      eventSlug: event['slug'] as String?,
      eventDate: _parseDate(event['event_date']),
      eventLocation: event['location'] as String?,
      ticketLink: event['ticket_link'] as String?,
      cardImageUrl: event['cardImageUrl'] as String?,
      flyerUrl: event['flyerUrl'] as String?,
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }

  /// The card image is the one the school prints the ticket QR code on, so it
  /// is the default; the flyer is the tall portrait version without one.
  String? get imageUrl => imageSource == 'flyer' ? flyerUrl : cardImageUrl;

  String get headline => headlineOverride ?? eventTitle ?? '';

  String get ctaLabel => ctaLabelOverride ?? 'Purchase tickets';

  /// The promoted event's own page, when it has a slug — `app.dart` only
  /// builds a route for events that do.
  String? get eventPath => eventSlug == null ? null : '/events/$eventSlug';

  /// Identifies this promo in the visitor's storage, so that pointing the
  /// splash at a different event shows it again for everyone without anyone
  /// having to bump a version field.
  ///
  /// Deliberately a slug or a plain timestamp rather than, say, the headline:
  /// this value is embedded in the boot script's JavaScript, and neither shape
  /// can contain a quote that would break out of the string.
  String get promoKey =>
      eventSlug ?? expiration?.millisecondsSinceEpoch.toString() ?? 'splash';

  /// Whether to emit the splash into the build at all. Deliberately strict:
  /// an expired or half-configured promo produces no markup, no boot script
  /// and no hydrated island, rather than something hidden by CSS.
  ///
  /// This is the build-time half of the expiry check. The browser re-checks
  /// the same window on every page load, which is what makes expiry land on
  /// time on a static site that might not rebuild for weeks.
  bool shouldRender(DateTime now) {
    if (!enabled) return false;
    if (expiration == null || !now.isBefore(expiration!)) return false;
    if (imageUrl == null || headline.isEmpty) return false;
    return true;
  }
}
