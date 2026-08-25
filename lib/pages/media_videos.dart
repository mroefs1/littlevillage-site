import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/seo_meta.dart';
import '../components/video_embed.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

// Media › Videos (Step 21). Backed by the `video` document type: paste a
// YouTube link into Sanity and it appears here, no deploy needed beyond the
// rebuild webhook.
//
// Embeds come from the shared `VideoEmbed` component (extracted from
// `portable_text_view.dart` this step), so this page adds no CSS — the
// heading and channel link reuse `.body-content`.
class MediaVideos extends AsyncStatelessComponent {
  const MediaVideos({super.key});

  static const _channelUrl = 'https://www.youtube.com/@thehagedornlittlevillagesc3516/videos';

  @override
  Future<Component> build(BuildContext context) async {
    final videos = await contentRepository.getVideos();

    return .fragment([
      const SeoMeta(
        title: 'Videos | $siteName',
        description: 'Videos from Hagedorn Little Village School, Jack Joel Center for Special Children.',
        path: '/media/videos',
      ),
      ContentPage(
        breadcrumb: 'Media › Videos',
        title: 'Videos',
        children: [
          if (videos.isEmpty)
            div(classes: 'body-content', [p([.text('Videos will appear here soon.')])])
          else
            for (final video in videos) ...[
              h2([.text(video.title)]),
              // The title doubles as the iframe's accessible name, so each
              // embed is distinguishable to a screen reader.
              VideoEmbed(url: video.youtubeUrl, caption: video.title),
              if (video.description case final description?)
                div(classes: 'body-content', [p([.text(description)])]),
            ],
          div(classes: 'body-content', [
            p([
              a(href: _channelUrl, target: Target.blank, [.text('See more on our YouTube channel →')]),
            ]),
          ]),
        ],
      ),
    ]);
  }
}
