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
import '../constants/theme.dart';
import '../sanity/models/program.dart';

// Per-category copy that isn't modeled in the `program` schema — the
// session/day timeline and services-pill list are fixed, structural content
// for exactly two categories now (same reasoning as Admissions' hardcoded
// steps/FAQ), not long-form copy Sanity should own. Early Intervention had
// its own entry here until Step 16, when it moved to a fully redesigned,
// Sanity-driven page (`early_intervention.dart`) — Preschool and Elementary
// keep this treatment for now, redesigned later the same way.
class _ProgramCopy {
  final String heroPhotoCaption;
  final String timelineTitle;
  final List<({String label, String desc})> timeline;
  final List<String> services;

  const _ProgramCopy({
    required this.heroPhotoCaption,
    required this.timelineTitle,
    required this.timeline,
    required this.services,
  });
}

const _copyByCategory = <String, _ProgramCopy>{
  'Preschool': _ProgramCopy(
    heroPhotoCaption: 'photo — preschool classroom activity',
    timelineTitle: 'A typical preschool day',
    timeline: [
      (label: '8:30 AM', desc: 'Arrival & morning circle — greetings, calendar, and social routines.'),
      (label: '9:15 AM', desc: 'Small-group learning centers: early literacy, fine motor, sensory play.'),
      (label: '10:30 AM', desc: 'Related services block — speech, OT, or PT, individually or in small groups.'),
      (label: '12:00 PM', desc: 'Lunch & supported peer social time.'),
      (label: '1:00 PM', desc: 'Outdoor play, music, or art, followed by dismissal prep.'),
    ],
    services: [
      'Speech & Language',
      'Occupational Therapy',
      'Physical Therapy',
      'Counseling',
      'Adaptive Physical Education',
    ],
  ),
  'Elementary': _ProgramCopy(
    heroPhotoCaption: 'photo — elementary classroom or therapy room',
    timelineTitle: 'A typical school day',
    timeline: [
      (label: '8:45 AM', desc: 'Bus arrival & homeroom.'),
      (label: '9:00 AM', desc: 'Core academics — reading, math, and writing in small groups.'),
      (label: '11:00 AM', desc: 'Related services block — speech, OT, PT, or counseling per the IEP.'),
      (label: '12:15 PM', desc: 'Lunch & recess.'),
      (label: '1:00 PM', desc: 'Specials — art, music, adaptive PE — and afternoon academics.'),
      (label: '3:00 PM', desc: 'Dismissal & bus departure.'),
    ],
    services: [
      'Speech & Language',
      'Occupational Therapy',
      'Physical Therapy',
      'Counseling & Social Work',
      'Adaptive Physical Education',
      'Transportation',
    ],
  ),
};

// Receives its program pre-fetched from [App] — see app.dart for why detail
// pages take data as a constructor param instead of querying by slug.
class ProgramDetail extends StatelessComponent {
  final Program program;

  const ProgramDetail(this.program, {super.key});

  @override
  Component build(BuildContext context) {
    final copy = _copyByCategory[program.category];

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
                PhotoPlaceholder(copy?.heroPhotoCaption ?? 'photo', height: 220.px),
            ]),
            div(classes: 'progd-hero-body', [
              if (program.ageRange != null) div(classes: 'progd-age-pill', [.text(program.ageRange!)]),
              PortableTextView(program.description),
            ]),
          ]),
          if (copy != null) ..._timelineAndServices(copy),
          const AdmissionsTeaser(),
          const CtaBand(),
        ],
      ),
    ]);
  }

  static List<Component> _timelineAndServices(_ProgramCopy copy) {
    return [
      div(classes: 'progd-timeline', [
        h2([.text(copy.timelineTitle)]),
        div(classes: 'progd-timeline-steps', [
          for (final step in copy.timeline)
            div(classes: 'progd-timeline-step', [
              div(classes: 'progd-timeline-step-label', [.text(step.label)]),
              div(classes: 'progd-timeline-step-desc', [.text(step.desc)]),
            ]),
        ]),
      ]),
      div(classes: 'progd-services', [
        div(classes: 'progd-services-title', [.text('Services included')]),
        PillList(copy.services),
      ]),
    ];
  }

  @css
  static List<StyleRule> get styles => [
    css('.progd-hero').styles(
      display: .flex,
      margin: .only(top: 10.px),
      alignItems: .start,
      gap: .all(26.px),
    ),
    css('.progd-hero-photo').styles(flex: Flex(grow: 1)),
    css('.progd-hero-img').styles(
      display: .block,
      width: 100.percent,
      height: 220.px,
      radius: .all(.circular(Radii.lg)),
      raw: {'object-fit': 'cover'},
    ),
    css('.progd-hero-body').styles(flex: Flex(grow: 1)),
    css('.progd-age-pill').styles(
      display: .inlineBlock,
      padding: .symmetric(vertical: 5.px, horizontal: 14.px),
      margin: .only(bottom: 12.px),
      radius: .all(.circular(Radii.pill)),
      color: AppColors.navyDark,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 13.px,
      fontWeight: .w700,
      backgroundColor: AppColors.yellow,
    ),

    css('.progd-timeline').styles(margin: .only(top: 26.px)),
    css('.progd-timeline h2').styles(fontWeight: .w600),
    css('.progd-timeline-steps').styles(
      display: .flex,
      margin: .only(top: 14.px),
      flexDirection: .column,
      gap: .all(10.px),
    ),
    css('.progd-timeline-step', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 12.px, horizontal: 16.px),
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.sm)),
        alignItems: .start,
        gap: .all(14.px),
      ),
      css('.progd-timeline-step-label').styles(
        width: 88.px,
        color: AppColors.coral,
        fontSize: 14.px,
        fontWeight: .w700,
        raw: {'flex': 'none'},
      ),
      css('.progd-timeline-step-desc').styles(color: AppColors.navy, fontSize: 14.px),
    ]),

    css('.progd-services').styles(margin: .only(top: 22.px)),
    css('.progd-services-title').styles(
      margin: .only(bottom: 10.px),
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 19.px,
      fontWeight: .w600,
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.progd-hero').styles(flexDirection: .column, alignItems: .stretch),
      css('.progd-timeline-step').styles(flexDirection: .column, gap: .all(4.px)),
      css('.progd-timeline-step-label').styles(width: .auto),
    ]),
  ];
}
