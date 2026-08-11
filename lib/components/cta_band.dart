import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

// The "Ready to take the first step?" band closing out Admissions, the
// Programs hub, and each program detail page — identical copy and CTAs
// everywhere it appears in the design handoff, so it takes no parameters.
class CtaBand extends StatelessComponent {
  const CtaBand({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'cta-band', [
      div(classes: 'cta-band-title', [.text('Ready to take the first step?')]),
      div(classes: 'cta-band-subtitle', [.text('We respond to every family within one business day.')]),
      div(classes: 'cta-band-actions', [
        Link(to: '/contact', classes: 'cta-band-btn-primary', child: .text('Request Information →')),
        Link(to: '/contact', classes: 'cta-band-btn-secondary', child: .text('Schedule a Tour')),
        a(href: 'tel:516-520-6000', classes: 'cta-band-btn-tertiary', [.text('📞 Call 516-520-6000')]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    // Light sky section with pill buttons — matches the same "closing CTA"
    // pattern used on Admissions (which has its own local copy of this
    // band rather than reusing this component; see admissions.dart's
    // .adm-cta rules).
    css('.cta-band').styles(
      padding: .all(40.px),
      margin: .only(top: 28.px),
      radius: .all(.circular(Radii.xxl)),
      textAlign: .center,
      backgroundColor: AppColors.sky,
    ),
    css('.cta-band-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 26.px,
      fontWeight: .w600,
    ),
    css('.cta-band-subtitle').styles(
      margin: .only(top: 6.px),
      color: AppColors.mutedText,
      fontSize: 15.px,
    ),
    css('.cta-band-actions').styles(
      display: .flex,
      margin: .only(top: 20.px),
      flexWrap: .wrap,
      justifyContent: .center,
      alignItems: .center,
      gap: .all(14.px),
    ),
    css('.cta-band-btn-primary').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 24.px),
      radius: .all(.circular(Radii.pill)),
      color: Colors.white,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
    ),
    css('.cta-band-btn-secondary').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 24.px),
      border: .all(color: AppColors.line, width: 2.px),
      radius: .all(.circular(Radii.pill)),
      color: AppColors.navy,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: Colors.white,
    ),
    css('.cta-band-btn-tertiary').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 24.px),
      border: .all(color: AppColors.line, width: 2.px),
      radius: .all(.circular(Radii.pill)),
      color: AppColors.navy,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: Colors.white,
    ),
  ];
}
