import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../sanity/models/portable_text.dart';
import '../sanity/models/program.dart';
import 'photo_placeholder.dart';
import 'pill_list.dart';
import 'portable_text_view.dart';

// Layout pieces shared by every program detail page — the photo/intro hero
// band and the "Services included" pill block. Each age-band program has its
// own bespoke page component (Early Intervention, Preschool, Elementary), so
// these live here rather than in any one of them: previously the `.progd-*`
// rules were owned by `program_detail.dart` and borrowed by the redesigned
// Early Intervention page, which meant deleting or reworking that template
// would have silently unstyled another page.

// The photo + age-pill + intro-paragraph band at the top of a program page.
class ProgramHero extends StatelessComponent {
  final Program program;

  /// Just the intro paragraph(s) — see [splitProgramDescription], which keeps
  /// the rest of the description out of the narrow hero column.
  final PortableText intro;

  const ProgramHero({required this.program, required this.intro, super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'progd-hero', [
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
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.progd-hero').styles(
      display: .flex,
      margin: .only(top: 10.px),
      alignItems: .start,
      gap: .all(26.px),
    ),
    // 1fr photo / 1.4fr text, matching the design handoff's hero grid. Both
    // columns need an explicit zero basis: with the default `auto` basis the
    // grow factors only divide up *leftover* space, so the long intro
    // paragraph claimed nearly the whole row and squeezed the photo to a
    // sliver.
    css('.progd-hero-photo').styles(flex: Flex(grow: 1, shrink: 1, basis: 0.px)),
    css('.progd-hero-img').styles(
      display: .block,
      width: 100.percent,
      aspectRatio: AspectRatio(4, 3),
      radius: .all(.circular(Radii.lg)),
      raw: {'object-fit': 'cover'},
    ),
    css('.progd-hero-body').styles(flex: Flex(grow: 1.4, shrink: 1, basis: 0.px)),
    css('.progd-age-pill').styles(
      display: .inlineBlock,
      padding: .symmetric(vertical: 5.px, horizontal: 14.px),
      margin: .only(bottom: 12.px),
      radius: .all(.circular(Radii.pill)),
      color: AppColors.navyDark,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 0.8125.rem,
      fontWeight: .w700,
      backgroundColor: AppColors.yellow,
    ),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.progd-hero').styles(flexDirection: .column, alignItems: .stretch),
    ]),
  ];
}

// The "Services included" pill row. The list stays a Dart literal on each
// page: it's a fixed, structural tag list, not long-form Sanity copy. Each
// pill deep links into the matching section of the Therapeutic Services page
// where one exists — see `constants/therapeutic_sections.dart`.
class ProgramServices extends StatelessComponent {
  final List<Pill> services;

  const ProgramServices(this.services, {super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'progd-services', [
      div(classes: 'progd-services-title', [.text('Services included')]),
      PillList(services),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.progd-services').styles(margin: .only(top: 22.px)),
    css('.progd-services-title').styles(
      margin: .only(bottom: 10.px),
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 1.1875.rem,
      fontWeight: .w600,
    ),
  ];
}

/// Splits a program's description into (intro, rest) at the first non-plain-
/// `block` item, so the intro paragraph(s) render in the narrow hero column
/// while process steps, service cards, and closing notes render full-width
/// below it.
(PortableText, PortableText) splitProgramDescription(PortableText description) {
  final splitIndex = description.blocks.indexWhere((block) => block['_type'] != 'block');
  if (splitIndex == -1) return (description, const PortableText([]));
  return (
    PortableText(description.blocks.sublist(0, splitIndex)),
    PortableText(description.blocks.sublist(splitIndex)),
  );
}
