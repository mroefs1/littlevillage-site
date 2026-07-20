import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';

class About extends StatelessComponent {
  const About({super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'About Us',
      title: 'About Us',
      lede:
          'The Hagedorn Little Village School, Jack Joel Center for Special Children (HLVS), is a publicly '
          'funded, not-for-profit school highly regarded for providing outstanding educational and '
          'therapeutic services for children with developmental disabilities.',
      children: [
        div(classes: 'link-grid', [
          _aboutLink('/mission', 'Mission Statement',
              'What we set out to do for every child and family we serve.'),
          _aboutLink('/history', 'Our History',
              'Over 50 years serving families across Long Island.'),
          _aboutLink('/founders', 'Founders', 'The two educators who started it all.'),
          _aboutLink('/facilities', 'School Facilities',
              'A 77,000 sq. ft. building built for learning and therapy.'),
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
