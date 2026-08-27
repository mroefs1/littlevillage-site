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
// links to it; Transportation isn't a therapeutic service and has no section
// to point at, so it stays inert.
final _servicesIncluded = [
  Pill('Speech & Language', href: TherapeuticSections.speechLanguage.link),
  Pill('Occupational Therapy', href: TherapeuticSections.occupationalTherapy.link),
  Pill('Physical Therapy', href: TherapeuticSections.physicalTherapy.link),
  Pill('Counseling & Social Work', href: TherapeuticSections.psychologicalSocialWork.link),
  Pill('Adaptive Physical Education', href: TherapeuticSections.adaptivePhysicalEducation.link),
  Pill('Transportation'),
];

// The Elementary School program's own detail page (Step 17), redesigned to
// match Early Intervention: a Sanity-driven CSE process band and one card per
// program/service, replacing the shared template's hardcoded day timeline.
// Still backed by the same `program` document (passed in pre-fetched from
// app.dart), so nav, the Programs hub card, and the homepage age-locator
// card keep working unchanged.
class Elementary extends StatelessComponent {
  final Program program;

  const Elementary(this.program, {super.key});

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
