import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';

class OurHistory extends StatelessComponent {
  const OurHistory({super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'About Us › Our History',
      title: 'Our History',
      lede:
          'The Hagedorn Little Village School has spent more than 50 years serving Long Island children and '
          'families with developmental delays and disabilities, as a publicly funded, not-for-profit school.',
      children: [
        div(classes: 'callout', [
          div(classes: 'callout-figure', [.text('50+')]),
          div([
            div(classes: 'callout-title', [.text('Years serving Long Island families')]),
            div(classes: 'callout-body', [
              .text(
                  'From our founding through today, our commitment to children with developmental delays and their families hasn\'t changed.'),
            ]),
          ]),
        ]),
        div(classes: 'info-card', [
          div(classes: 'info-card-header', [.text('More history, coming soon')]),
          div(classes: 'info-card-body', [
            p([
              .text(
                  'Our full historical record is preserved in the school\'s archival documents. We\'re in the '
                  'process of transcribing that material for the new site — check back soon, or see our '),
              Link(to: '/founders', child: .text('founders')),
              .text(' page in the meantime.'),
            ]),
          ]),
        ]),
      ],
    );
  }
}
