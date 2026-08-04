import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

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
// for exactly three categories (same reasoning as Admissions' hardcoded
// steps/FAQ), not long-form copy Sanity should own.
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
  'Early Intervention': _ProgramCopy(
    heroPhotoCaption: 'photo — home visit or center-based EI session',
    timelineTitle: 'What a session looks like',
    timeline: [
      (
        label: 'Arrival',
        desc: "Your Early Intervention provider arrives at the agreed time and setting — home, center, or daycare.",
      ),
      (
        label: 'Session',
        desc: '30–60 minutes of play-based therapy targeting communication, motor skills, feeding, or social development.',
      ),
      (label: 'Check-in', desc: 'Providers coach caregivers on carrying strategies into daily routines between visits.'),
      (label: 'Progress review', desc: 'Every six months, the team and family review the IFSP and adjust goals together.'),
    ],
    services: ['Speech & Language', 'Occupational Therapy', 'Physical Therapy', 'Special Instruction', 'Family Training'],
  ),
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
    services: ['Speech & Language', 'Occupational Therapy', 'Physical Therapy', 'Counseling', 'Adaptive Physical Education'],
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
          _howToStart(),
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

  static Component _howToStart() {
    return div(classes: 'progd-how-to-start', [
      div([
        div(classes: 'progd-how-to-start-title', [.text('Ready to see if this program is the right fit?')]),
        div(classes: 'progd-how-to-start-desc', [.text('Read the full step-by-step admissions guide.')]),
      ]),
      Link(to: '/admissions', classes: 'progd-how-to-start-cta', child: .text('Admissions guide →')),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.progd-hero').styles(display: .flex, margin: .only(top: 10.px), alignItems: .start, gap: .all(26.px)),
    css('.progd-hero-photo').styles(flex: Flex(grow: 1)),
    css('.progd-hero-img').styles(
      display: .block,
      width: 100.percent,
      height: 220.px,
      radius: .all(.circular(10.px)),
      raw: {'object-fit': 'cover'},
    ),
    css('.progd-hero-body').styles(flex: Flex(grow: 1)),
    css('.progd-age-pill').styles(
      display: .inlineBlock,
      padding: .symmetric(vertical: 4.px, horizontal: 12.px),
      margin: .only(bottom: 12.px),
      radius: .all(.circular(20.px)),
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 14.px,
      backgroundColor: AppColors.pillTint,
    ),

    css('.progd-timeline').styles(margin: .only(top: 26.px)),
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
        border: .all(color: AppColors.borderLight, width: 2.px),
        radius: .all(.circular(8.px)),
        alignItems: .start,
        gap: .all(14.px),
      ),
      css('.progd-timeline-step-label').styles(
        width: 88.px,
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
        fontWeight: .w700,
        raw: {'flex': 'none'},
      ),
      css('.progd-timeline-step-desc').styles(color: AppColors.ink, fontSize: 14.px),
    ]),

    css('.progd-services').styles(margin: .only(top: 22.px)),
    css('.progd-services-title').styles(
      margin: .only(bottom: 10.px),
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 20.px,
      fontWeight: .w700,
    ),

    css('.progd-how-to-start').styles(
      display: .flex,
      padding: .symmetric(vertical: 18.px, horizontal: 22.px),
      margin: .only(top: 24.px),
      border: .all(color: AppColors.utilityBorder, width: 2.px),
      radius: .all(.circular(10.px)),
      justifyContent: .spaceBetween,
      alignItems: .center,
      gap: .all(16.px),
      backgroundColor: AppColors.lightBlueTint,
    ),
    css('.progd-how-to-start-title').styles(
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 17.px,
      fontWeight: .w700,
    ),
    css('.progd-how-to-start-desc').styles(margin: .only(top: 3.px), color: AppColors.body, fontSize: 13.px),
    css('.progd-how-to-start-cta').styles(
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 15.px,
      fontWeight: .w700,
      whiteSpace: .noWrap,
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.progd-hero').styles(flexDirection: .column, alignItems: .stretch),
      css('.progd-timeline-step').styles(flexDirection: .column, gap: .all(4.px)),
      css('.progd-timeline-step-label').styles(width: .auto),
      css('.progd-how-to-start').styles(flexDirection: .column, textAlign: .center),
    ]),
  ];
}
