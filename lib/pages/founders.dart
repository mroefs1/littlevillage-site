import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/content_page.dart';

class Founders extends StatelessComponent {
  const Founders({super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'About Us › Founders',
      title: 'Founders',
      lede:
          'The Hagedorn Little Village School was founded by two educators whose work shaped decades of '
          'special education on Long Island.',
      children: [
        div(classes: 'person-grid', [
          _founderCard(
            initials: 'CB',
            name: 'Caryl Bank, Ph.D.',
            credentials:
                'B.A. Psychology (Boston University) · M.S. Special Education (City College) · '
                'M.S.W. (Adelphi University) · D.S.W. (New York University)',
            bio:
                'Co-founder of the school, Dr. Bank dedicated her career to special education innovation and to '
                'supporting children and families — work through which, in the school\'s words, "thousands of '
                'children have reached milestones they and their families never imagined possible." She passed '
                'away on January 31, 2016.',
          ),
          _founderCard(
            initials: 'BF',
            name: 'Barbara Feingold, Ph.D.',
            credentials:
                'B.A. Psychology (Queens College) · M.A. Educational Psychology (New York University) · '
                'Ph.D. Psychology (Hofstra University)',
            bio:
                'Co-founder of the school, Dr. Feingold is a certified special education teacher and a licensed '
                'psychologist in New York State, with additional certifications in administration, supervision, '
                'and school psychology.',
          ),
        ]),
      ],
    );
  }

  static Component _founderCard({
    required String initials,
    required String name,
    required String credentials,
    required String bio,
  }) {
    return div(classes: 'person-card', [
      div(classes: 'person-avatar', [.text(initials)]),
      div(classes: 'person-name', [.text(name)]),
      div(classes: 'person-credentials', [.text(credentials)]),
      div(classes: 'person-bio', [.text(bio)]),
    ]);
  }
}
