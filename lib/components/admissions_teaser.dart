import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

// The "Ready to see if this program is the right fit?" sky teaser band
// linking to the Admissions guide — shared by every program detail page
// (age-band or standalone), same copy everywhere it appears.
class AdmissionsTeaser extends StatelessComponent {
  const AdmissionsTeaser({super.key});

  @override
  Component build(BuildContext context) {
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
    css('.progd-how-to-start').styles(
      display: .flex,
      padding: .symmetric(vertical: 22.px, horizontal: 26.px),
      margin: .only(top: 24.px),
      radius: .all(.circular(Radii.xxl)),
      justifyContent: .spaceBetween,
      alignItems: .center,
      gap: .all(16.px),
      backgroundColor: AppColors.sky,
    ),
    css('.progd-how-to-start-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 17.px,
      fontWeight: .w600,
    ),
    css('.progd-how-to-start-desc').styles(
      margin: .only(top: 3.px),
      color: AppColors.mutedText,
      fontSize: 13.px,
    ),
    // Plain coral text link, not a pill button — matches the same
    // "in-card CTA" treatment used elsewhere (home's enrollment-teaser
    // link, age-card/current-families card CTAs), reserving pill buttons
    // for primary navigation actions.
    css('.progd-how-to-start-cta').styles(
      color: AppColors.coral,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 14.px,
      fontWeight: .w700,
      whiteSpace: .noWrap,
    ),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.progd-how-to-start').styles(flexDirection: .column, textAlign: .center),
    ]),
  ];
}
