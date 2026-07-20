import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';

class Contact extends StatelessComponent {
  const Contact({super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'Contact',
      title: 'Contact Us',
      lede: 'We respond to every family and community inquiry as quickly as we can. Reach us by phone, '
          'email, or mail.',
      children: [
        div(classes: 'info-card', [
          div(classes: 'info-card-header', [.text('Get in Touch')]),
          div(classes: 'info-card-body', [
            p([.text('Phone: '), a(href: 'tel:+15165206000', [.text('516-520-6000')])]),
            p([.text('Email: '), a(href: 'mailto:information@littlevillage.org', [.text('information@littlevillage.org')])]),
            p([.text('Address: The Hagedorn Little Village School, 750 Hicksville Rd., Seaford, NY 11783')]),
            p([.text('The school is located behind the Northwell Health doctors\' offices.')]),
          ]),
        ]),
      ],
    );
  }
}
