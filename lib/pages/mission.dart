import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';

class Mission extends StatelessComponent {
  const Mission({super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'About Us › Mission Statement',
      title: 'Mission Statement',
      lede:
          'The mission of The Hagedorn Little Village School (HLVS) Jack Joel Center for Special Children '
          'is to provide the finest educational and therapeutic programs to infants, pre-school and '
          'elementary school children with a wide range of developmental delays and disabilities — helping '
          'each child achieve their highest potential, educationally, emotionally and socially, by creating '
          'a nurturing environment for the child and a supportive framework for their families.',
      children: [
        div(classes: 'info-card', [
          div(classes: 'info-card-header', [.text('Guiding Philosophy')]),
          div(classes: 'info-card-body', [
            ul([
              li([
                .text(
                    'Facilitating children in reaching their highest potential across social, educational, and emotional domains.'),
              ]),
              li([.text('Offering assistance and guidance to families.')]),
              li([.text('Partnering with external service providers to accomplish these goals.')]),
            ]),
          ]),
        ]),
        div(classes: 'info-card', [
          div(classes: 'info-card-header', [.text('Core Values')]),
          div(classes: 'info-card-body', [
            ul([
              li([.text('Providing empathetic care to all constituencies.')]),
              li([.text('Maintaining deep regard for the dignity of each child.')]),
              li([.text('Conducting ethical business practices.')]),
              li([
                .text(
                    'Supporting continuous staff development, to ensure that our children receive the most current and effective instruction and therapeutic interventions.'),
              ]),
            ]),
          ]),
        ]),
      ],
    );
  }
}
