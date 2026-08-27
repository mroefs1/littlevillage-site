import 'package:jaspr/jaspr.dart';

import '../components/admissions_teaser.dart';
import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/pill_list.dart';
import '../components/portable_text_view.dart';
import '../components/program_layout.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/therapeutic_sections.dart';
import '../sanity/models/program.dart';

// Fixed, structural tag list — see ProgramServices for why this stays in Dart.
// Each pill deep links to its section on the Therapeutic Services page.
final _servicesIncluded = [
  Pill('Speech & Language', href: TherapeuticSections.speechLanguage.link),
  Pill('Occupational Therapy', href: TherapeuticSections.occupationalTherapy.link),
  Pill('Physical Therapy', href: TherapeuticSections.physicalTherapy.link),
  Pill('Counseling', href: TherapeuticSections.psychologicalSocialWork.link),
  Pill('Adaptive Physical Education', href: TherapeuticSections.adaptivePhysicalEducation.link),
];

// The Preschool program's own detail page (Step 17), redesigned to match
// Early Intervention: a Sanity-driven CPSE process band and one card per
// program/service, replacing the shared template's hardcoded day timeline.
// Still backed by the same `program` document (passed in pre-fetched from
// app.dart), so nav, the Programs hub card, and the homepage age-locator
// card keep working unchanged.
class Preschool extends StatelessComponent {
  final Program program;

  const Preschool(this.program, {super.key});

  @override
  Component build(BuildContext context) {
    final (intro, rest) = splitProgramDescription(program.description);

    return .fragment([
      SeoMeta(
        title: '${program.title} | $siteName',
        description: !program.description.isEmpty
            ? truncateForMeta(program.description.plainText)
            : 'Learn about the ${program.title} program at Hagedorn Little Village School.',
        path: '/programs/${program.slug}',
      ),
      ContentPage(
        breadcrumb: 'Programs › ${program.title}',
        title: program.title,
        children: [
          ProgramHero(program: program, intro: intro),
          PortableTextView(rest),
          ProgramServices(_servicesIncluded),
          const AdmissionsTeaser(),
          const CtaBand(),
        ],
      ),
    ]);
  }
}
