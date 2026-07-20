import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';

class Facilities extends StatelessComponent {
  const Facilities({super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'School Facilities',
      title: 'School Facilities',
      lede:
          'Our state-of-the-art building was designed for both learning and therapy — from accessible '
          'classrooms and a sensory gym to two dedicated physical therapy centers.',
      children: [
        div(classes: 'callout', [
          div(classes: 'callout-figure', [.text('77,000')]),
          div([
            div(classes: 'callout-title', [.text('Square feet, and growing')]),
            div(classes: 'callout-body', [
              .text(
                  'The school opened in July 2002 at 60,000 sq. ft. and expanded to 77,000 sq. ft. in January 2014.'),
            ]),
          ]),
        ]),
        div(classes: 'info-card', [
          div(classes: 'info-card-header', [.text('The Building')]),
          div(classes: 'info-card-body', [
            p([
              .text(
                  'The building is fully wheelchair accessible and air conditioned. Security measures include '
                  'locked entrance doors, employee ID badges with electronic access, visitor sign-in, and video '
                  'monitoring of hallways and exterior areas. Staff are trained on the RAVE Panic Button app, '
                  'which instantly alerts 9-1-1 and connects on-site personnel with first responders during an '
                  'emergency.'),
            ]),
          ]),
        ]),
        div(classes: 'info-card', [
          div(classes: 'info-card-header', [.text('Outdoor Spaces')]),
          div(classes: 'info-card-body', [
            p([
              .text(
                  'A 23,400 sq. ft. handicapped-accessible playground supports gross motor development and '
                  'imaginative play, with soft, impact-resistant all-weather surfacing, an emergency phone, '
                  'security fencing, and video surveillance. A separate fenced turf area is dedicated to '
                  'organized sports.'),
            ]),
          ]),
        ]),
        div(classes: 'info-card', [
          div(classes: 'info-card-header', [.text('Athletic & Therapeutic Facilities')]),
          div(classes: 'info-card-body', [
            p([
              .text(
                  'A full-sized gymnasium is equipped with modified equipment for individual student needs, '
                  'supporting activities like basketball, T-ball, and obstacle courses. The sensory gym in the '
                  'occupational and physical therapy center includes suspended swings, mobile apparatus, and '
                  'climbing equipment. Two Physical Therapy Centers house treadmills, adaptive standers, '
                  'walkers, bicycles, and balance training equipment.'),
            ]),
          ]),
        ]),
      ],
    );
  }
}
