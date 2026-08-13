import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/admissions_teaser.dart';
import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/photo_placeholder.dart';
import '../components/pill_list.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/models/portable_text.dart';
import '../sanity/models/program.dart';

// Fixed, structural tag list (same reasoning as program_detail.dart's
// hardcoded per-category services lists) — not long-form Sanity copy.
const _servicesIncluded = [
  'Speech & Language',
  'Occupational Therapy',
  'Physical Therapy',
  'Special Instruction',
  'Family Training',
];

// Early Intervention's own redesigned detail page (Step 16) - split off
// from the shared `ProgramDetail` template used by Preschool/Elementary,
// since its content no longer fits that template's fixed hero+timeline
// shape. Still backed by the same `program` Sanity document (passed in
// pre-fetched from app.dart, same as `ProgramDetail`), so nav, the
// Programs hub card, and the homepage age-locator card all keep working
// unchanged - only this page's own rendering differs.
class EarlyIntervention extends StatelessComponent {
  final Program program;

  const EarlyIntervention(this.program, {super.key});

  @override
  Component build(BuildContext context) {
    final (intro, rest) = _splitDescription(program.description);

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
          div(classes: 'progd-hero', [
            div(classes: 'progd-hero-photo', [
              if (program.imageUrl != null)
                img(src: program.imageUrl!, alt: program.title, classes: 'progd-hero-img')
              else
                PhotoPlaceholder('photo', height: 220.px),
            ]),
            div(classes: 'progd-hero-body', [
              if (program.ageRange != null) div(classes: 'progd-age-pill', [.text(program.ageRange!)]),
              PortableTextView(intro),
            ]),
          ]),
          PortableTextView(rest),
          div(classes: 'progd-services', [
            div(classes: 'progd-services-title', [.text('Services included')]),
            const PillList(_servicesIncluded),
          ]),
          const AdmissionsTeaser(),
          const CtaBand(),
        ],
      ),
    ]);
  }

  // Splits the hero's intro paragraph(s) from everything else (process
  // steps, service cards, closing notes) at the first non-plain-`block`
  // item, so the intro renders in the narrow hero column while the rest
  // renders full-width below it. `program_detail.dart`'s CSS classes
  // (.progd-hero, .progd-services, etc.) are reused here since that file
  // is still compiled into the site for Preschool/Elementary.
  static (PortableText, PortableText) _splitDescription(PortableText description) {
    final splitIndex = description.blocks.indexWhere((block) => block['_type'] != 'block');
    if (splitIndex == -1) return (description, const PortableText([]));
    return (
      PortableText(description.blocks.sublist(0, splitIndex)),
      PortableText(description.blocks.sublist(splitIndex)),
    );
  }
}
