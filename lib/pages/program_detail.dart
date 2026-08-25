import 'package:jaspr/jaspr.dart';

import '../components/admissions_teaser.dart';
import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/portable_text_view.dart';
import '../components/program_layout.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/models/program.dart';

// Generic fallback for a `program` document without its own bespoke page.
//
// Each of the three age bands now has one (Early Intervention in Step 16,
// Preschool and Elementary in Step 17), so nothing routes here today — but
// app.dart builds one route per program document, so a program added in
// Sanity later (the schema's category list also allows Family Services, CPSE
// Evaluations, and Summer Rec) still renders its content instead of hitting a
// dead route. Purely Sanity-driven: whatever block types the description
// holds, rendered in order. The hardcoded per-category "typical day" timeline
// this template used to carry was retired in Step 17.
class ProgramDetail extends StatelessComponent {
  final Program program;

  const ProgramDetail(this.program, {super.key});

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
          const AdmissionsTeaser(),
          const CtaBand(),
        ],
      ),
    ]);
  }
}
