import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';
import '../components/photo_placeholder.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';

// Placeholder page reserving the /support-us route and About-dropdown link
// for a future donation widget. The Give Lively embed (see CLAUDE.md's
// "Givelively Donation Widget" section) was tried here and pulled back out
// pending a decision on whether to use it — swap the placeholder below for
// that embed (or another provider's) once that's settled.
class SupportUs extends StatelessComponent {
  const SupportUs({super.key});

  @override
  Component build(BuildContext context) {
    return .fragment([
      const SeoMeta(
        title: 'Support Us | $siteName',
        description: 'Support Hagedorn Little Village School with a donation through Give Lively.',
        path: '/support-us',
      ),
      ContentPage(
        breadcrumb: 'Support Us',
        title: 'Support Us',
        children: [
          p(classes: 'support-us-subtitle', [
            .text(
              'Your gift helps keep our programs tuition-free for every family. '
              "We're finalizing how to take donations online — check back soon.",
            ),
          ]),
          PhotoPlaceholder('donation widget placeholder', height: 320.px),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.support-us-subtitle').styles(
      maxWidth: 640.px,
      margin: .only(top: 10.px, bottom: 24.px),
      color: AppColors.mutedText,
      fontSize: 16.px,
      lineHeight: 1.55.em,
    ),
  ];
}
