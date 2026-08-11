import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/photo_placeholder.dart';
import '../components/pill_list.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/models/program.dart';

// The three age-band categories with their own detail page (see
// program_detail.dart). Other `program` categories (Therapeutic Services,
// Family Services, CPSE Evaluations, Summer Rec) aren't part of this
// age-locator pattern and aren't shown on this hub.
const _ageBandCategories = ['Early Intervention', 'Preschool', 'Elementary'];

// Receives the full program list pre-fetched from [App], same as
// news/events — see app.dart.
class Programs extends StatelessComponent {
  final List<Program> programs;

  const Programs({required this.programs, super.key});

  @override
  Component build(BuildContext context) {
    final ageBandPrograms = [
      for (final category in _ageBandCategories)
        for (final program in programs)
          if (program.category == category) program,
    ];

    return .fragment([
      const SeoMeta(
        title: 'Programs & Enrollment | $siteName',
        description:
            'One continuum of tuition-free special education, from Early Intervention through elementary school, '
            'with on-site therapy built into every program.',
        path: '/programs',
      ),
      ContentPage(
        breadcrumb: 'Programs',
        title: 'One continuum, from birth through elementary school.',
        children: [
          p(classes: 'prog-subtitle', [
            .text(
              "Every program pairs learning with on-site therapy, built around your child's Individualized "
              "Education Program (IEP) or Individualized Family Service Plan (IFSP).",
            ),
          ]),
          if (ageBandPrograms.isEmpty)
            p([.text('Program details are coming soon.')])
          else
            div(classes: 'prog-cards', [for (final program in ageBandPrograms) _card(program)]),
          _therapiesStrip(),
          const CtaBand(),
        ],
      ),
    ]);
  }

  static Component _card(Program program) {
    final excerpt = _excerpt(program.description.plainText);
    return Link(
      to: '/programs/${program.slug}',
      classes: 'prog-card',
      child: .fragment([
        if (program.imageUrl != null)
          img(src: program.imageUrl!, alt: program.title, classes: 'prog-card-photo')
        else
          PhotoPlaceholder('photo', height: 220.px),
        div(classes: 'prog-card-age', [.text(program.ageRange ?? '')]),
        div(classes: 'prog-card-name', [.text(program.title)]),
        if (excerpt != null) div(classes: 'prog-card-desc', [.text(excerpt)]),
        div(classes: 'prog-card-cta', [.text('Program details →')]),
      ]),
    );
  }

  static Component _therapiesStrip() {
    return div(classes: 'prog-therapies', [
      div(classes: 'prog-therapies-title', [.text('On-site therapy, woven into every program')]),
      const PillList([
        'Speech & Language',
        'Occupational Therapy',
        'Physical Therapy',
        'Counseling & Social Work',
        'Vision & Hearing Services',
      ]),
    ]);
  }

  static String? _excerpt(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length <= 140) return trimmed;
    return '${trimmed.substring(0, 140).trimRight()}…';
  }

  @css
  static List<StyleRule> get styles => [
    css('.prog-subtitle').styles(
      maxWidth: 640.px,
      margin: .only(top: 10.px),
      color: AppColors.mutedText,
      fontSize: 16.px,
      lineHeight: 1.55.em,
    ),
    css('.prog-cards').styles(
      display: .flex,
      margin: .only(top: 14.px),
      gap: .all(16.px),
    ),
    // Same per-card pastel treatment as the homepage age-locator cards
    // (literally the same three age-band programs) - peach/sky/mint via
    // nth-child, real photo kept.
    css('.prog-card', [
      css('&').styles(
        display: .block,
        padding: .all(20.px),
        radius: .all(.circular(Radii.xl)),
        flex: Flex(grow: 1),
        backgroundColor: AppColors.peach,
      ),
      css('&:nth-child(2)').styles(backgroundColor: AppColors.sky),
      css('&:nth-child(3)').styles(backgroundColor: AppColors.mint),
      css('.prog-card-photo').styles(
        display: .block,
        width: 100.percent,
        height: 220.px,
        radius: .all(.circular(Radii.md)),
        raw: {'object-fit': 'cover'},
      ),
      css('.prog-card-age').styles(
        margin: .only(top: 14.px),
        color: AppColors.mutedTextLight,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 12.px,
        fontWeight: .w800,
        textTransform: .upperCase,
        letterSpacing: 0.1.em,
      ),
      css('.prog-card-name').styles(
        margin: .only(top: 8.px),
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 20.px,
        fontWeight: .w600,
      ),
      css('.prog-card-desc').styles(
        margin: .only(top: 6.px),
        color: AppColors.mutedTextMid,
        fontSize: 13.px,
        lineHeight: 1.5.em,
      ),
      css('.prog-card-cta').styles(
        margin: .only(top: 12.px),
        color: AppColors.coral,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 14.px,
        fontWeight: .w700,
      ),
    ]),
    css('.prog-therapies').styles(
      padding: .symmetric(vertical: 24.px, horizontal: 26.px),
      margin: .only(top: 26.px),
      radius: .all(.circular(Radii.xxl)),
      backgroundColor: AppColors.mint,
    ),
    css('.prog-therapies-title').styles(
      margin: .only(bottom: 12.px),
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 19.px,
      fontWeight: .w600,
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.prog-cards').styles(flexDirection: .column),
    ]),
  ];
}
