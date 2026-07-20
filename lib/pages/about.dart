import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../sanity/content_repository.dart';

// The link grid stays hardcoded — it's site navigation/structure, not
// editorial content, so it belongs in Jaspr rather than Sanity (see
// CLAUDE.md's content boundary). Only the intro copy comes from Sanity.
class About extends AsyncStatelessComponent {
  const About({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('about');

    return ContentPage(
      breadcrumb: 'About Us',
      title: page?.title ?? 'About Us',
      children: [
        if (page != null) PortableTextView(page.body),
        div(classes: 'link-grid', [
          _aboutLink('/mission', 'Mission Statement',
              'What we set out to do for every child and family we serve.'),
          _aboutLink('/history', 'Our History',
              'Over 50 years serving families across Long Island.'),
          _aboutLink('/founders', 'Founders', 'The two educators who started it all.'),
          _aboutLink('/facilities', 'School Facilities',
              'A 77,000 sq. ft. building built for learning and therapy.'),
          _aboutLink('/staff', 'Admin Staff', 'The team leading our programs day to day.'),
          _aboutLink('/board', 'Board Members', 'The volunteers who govern the school.'),
        ]),
      ],
    );
  }

  static Component _aboutLink(String path, String title, String body) {
    return Link(
      to: path,
      classes: 'link-card',
      child: .fragment([
        div(classes: 'link-card-title', [.text(title)]),
        div(classes: 'link-card-body', [.text(body)]),
        div(classes: 'link-card-cta', [.text('Learn more →')]),
      ]),
    );
  }
}
