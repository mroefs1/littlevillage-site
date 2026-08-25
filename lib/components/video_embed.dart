import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

// A responsive YouTube embed.
//
// Extracted out of `portable_text_view.dart` in Step 21 so the Videos page and
// the `videoEmbed` portable-text block (mid-article embeds like the one on
// Data Privacy) share one implementation — same extract-don't-duplicate
// reasoning as `AdmissionsTeaser` (Step 16) and `program_layout.dart`
// (Step 17).
//
// Uses `youtube-nocookie.com`, the privacy-enhanced domain that sets no
// tracking cookie until the visitor actually clicks play.
class VideoEmbed extends StatelessComponent {
  final String? url;
  final String? caption;

  const VideoEmbed({required this.url, this.caption, super.key});

  @override
  Component build(BuildContext context) {
    final videoId = url == null ? null : extractYoutubeId(url!);
    if (videoId == null) return .fragment([]);
    return div(classes: 'video-embed', [
      iframe(
        src: 'https://www.youtube-nocookie.com/embed/$videoId',
        allow:
            'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share',
        loading: MediaLoading.lazy,
        classes: 'video-embed-frame',
        // Never blank and never a bare "video" — a screen reader needs to be
        // able to tell one embed from another.
        attributes: {'title': caption ?? 'Embedded video', 'allowfullscreen': 'true'},
        const [],
      ),
      if (caption != null) p(classes: 'video-embed-caption', [.text(caption!)]),
    ]);
  }

  /// Accepts the editor-friendly URL shapes a YouTube field would realistically
  /// hold — `watch?v=`, `youtu.be/`, `embed/`, `shorts/` — rather than
  /// assuming one specific format.
  static String? extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final fromQuery = uri.queryParameters['v'];
    if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
    if (segments.isEmpty) return null;
    if (uri.host.contains('youtu.be')) return segments.first;
    if (segments.first == 'embed' || segments.first == 'shorts') {
      return segments.length > 1 ? segments[1] : null;
    }
    return null;
  }

  @css
  static List<StyleRule> get styles => [
    css('.video-embed', [
      css('&').styles(margin: .only(top: 14.px)),
      css('.video-embed-frame').styles(
        display: .block,
        width: 100.percent,
        aspectRatio: AspectRatio(16, 9),
        border: .none,
        radius: .all(.circular(Radii.md)),
      ),
      css('.video-embed-caption').styles(
        margin: .only(top: 8.px),
        color: AppColors.mutedTextLight,
        fontSize: 13.px,
      ),
    ]),
  ];
}
