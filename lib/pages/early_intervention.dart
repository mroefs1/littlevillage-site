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
// Each pill that has a matching section on the Therapeutic Services page deep
// links to it; Special Instruction and Family Training aren't therapeutic
// services and have no section to point at, so they stay inert.
final _servicesIncluded = [
  Pill('Speech & Language', href: TherapeuticSections.speechLanguage.link),
  Pill('Occupational Therapy', href: TherapeuticSections.occupationalTherapy.link),
  Pill('Physical Therapy', href: TherapeuticSections.physicalTherapy.link),
  Pill('Special Instruction'),
  Pill('Family Training'),
];

// Early Intervention's own redesigned detail page (Step 16). Backed by the
// same `program` Sanity document as every other age band (passed in
// pre-fetched from app.dart), so nav, the Programs hub card, and the homepage
// age-locator card all keep working unchanged — only this page's own
// rendering differs. Its hero/services markup and CSS moved into the shared
// `program_layout.dart` in Step 17, when Preschool and Elementary got the
// same treatment.
class EarlyIntervention extends StatelessComponent {
  final Program program;

  const EarlyIntervention(this.program, {super.key});

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
