import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/faq_accordion.dart';
import '../components/photo_placeholder.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/page_content.dart';

class Admissions extends AsyncStatelessComponent {
  const Admissions({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('admissions');

    return .fragment([
      // This page had no SeoMeta at all until 2026-10-08 - the only content
      // page on the site without one. It meant no canonical tag (so the
      // pages.dev copy was indexable alongside the real domain), a bare
      // "Admissions" title, no Open Graph card when the page is shared, and
      // the sitewide fallback description.
      SeoMeta(
        title: 'Admissions | $siteName',
        description:
            'Enrolling at HLVS: eligibility, evaluation and referral through EI, CPSE or CSE, and '
            'placement for children with autism and developmental delays.',
        path: '/admissions',
        image: page?.heroImage?.url,
      ),
      ContentPage(
        breadcrumb: 'Admissions',
        title: "We'll walk you through it, step by step.",
        // No `gallery:` here on purpose — this page's `images` are consumed
        // positionally by the enrollment-journey steps below, one per step,
        // so passing them through as well would render every photo twice.
        heroImage: page?.heroImage,
        children: [
          p(classes: 'adm-subtitle', [
            .text(
              "Getting services for your child can feel like a maze of acronyms. It isn't, really — and you won't "
              "do it alone. Here's exactly how it works and where we fit in.",
            ),
          ]),
          _eligibility(),
          _journey(page?.images ?? const []),
          _tuitionCallout(),
          _faq(),
          _ctaBand(),
        ],
      ),
    ]);
  }

  static Component _eligibility() {
    const checks = [
      (label: 'Lives in New York', desc: 'Services are funded through your county & school district.'),
      (label: 'Birth to 12 years', desc: 'From Early Intervention through elementary school.'),
      (
        label: 'A diagnosed or suspected delay',
        desc: "You don't need answers yet — a suspicion is enough to start.",
      ),
    ];
    return div(classes: 'adm-eligibility', [
      div(classes: 'adm-eligibility-header', [.text('Is my child eligible?')]),
      div(classes: 'adm-eligibility-checks', [
        for (final check in checks)
          div(classes: 'adm-eligibility-check', [
            div(classes: 'adm-eligibility-check-label', [.text('✓ ${check.label}')]),
            div(classes: 'adm-eligibility-check-desc', [.text(check.desc)]),
          ]),
      ]),
      div(classes: 'adm-eligibility-note', [
        .text('Not sure? '),
        span(classes: 'adm-eligibility-note-cta', [.text("Call us and we'll help you figure it out → 516-520-6000")]),
      ]),
    ]);
  }

  static Component _journey(List<PageImage> images) {
    // Copy supplied by the Admissions department, 2026-10-08. `paras` is a
    // list because step 3 is two paragraphs in the source document.
    const steps = [
      (
        n: '1',
        title: 'Reach out to us',
        paras: [
          "Feel free to reach out to us. We'll listen, answer questions, and point you in the right "
              "direction, whether that be Early Intervention (Birth-3) or your school district's CPSE "
              "(3-5 yrs old) or CSE (ages 5 and up).",
        ],
      ),
      (
        n: '2',
        title: 'Evaluation & referral',
        paras: [
          'Once a referral is received through Early Intervention or through your school district, a '
              'multidisciplinary evaluation will be completed at no cost to you. These evaluations will '
              "assess your child's individual needs. Pending completion of these evaluations your EI Team "
              'or CPSE/CSE team will determine eligibility for services and/or program placement.',
          'In CPSE, if a center-based special education preschool program is recommended for your child, '
              "your district will send your child's packet to various programs, including but not limited "
              'to The Hagedorn Little Village School. At the school-age level, if the CSE determines that '
              'your child meets eligibility for an out-of-district school placement, a referral will be '
              'sent to Little Village.',
        ],
      ),
      (
        n: '3',
        title: 'Visit our program',
        paras: [
          'You are more than welcome to contact us to schedule a general Open House tour of our program.',
          "Following receipt of your child's packet, our Admissions Department may call to schedule a "
              'screening with your child for possible placement, pending an appropriate opening.',
        ],
      ),
      (
        n: '4',
        title: 'Placement & beyond',
        paras: [
          'Once placement is secured, we will work as a team with you and your school district to handle '
              'all of the logistics, including transportation. Our staff who will be working with your '
              'child on a daily basis will keep in touch with you every step of the way!',
        ],
      ),
    ];
    return div(classes: 'adm-journey', [
      h2([.text('The enrollment journey')]),
      div(classes: 'adm-journey-steps', [
        for (final (i, step) in steps.indexed)
          div(classes: 'adm-journey-step', [
            div(classes: 'adm-journey-step-badge', [.text(step.n)]),
            div(classes: 'adm-journey-step-body', [
              div(classes: 'adm-journey-step-title', [.text(step.title)]),
              for (final para in step.paras) div(classes: 'adm-journey-step-desc', [.text(para)]),
            ]),
            div(classes: 'adm-journey-step-photo', [
              if (i < images.length)
                img(
                  src: images[i].url,
                  alt: images[i].alt,
                  classes: 'adm-journey-step-img',
                  // Editors have set a focal point on all four of these in
                  // the Studio; without this the crop silently centred and
                  // ignored them.
                  styles: switch (images[i].objectPosition) {
                    final position? => Styles(raw: {'object-position': position}),
                    null => null,
                  },
                )
              else
                // No explicit height — an inline one would beat the shared
                // aspect-ratio rule below and make this step shorter than
                // its siblings.
                PhotoPlaceholder(''),
            ]),
          ]),
      ]),
    ]);
  }

  static Component _tuitionCallout() {
    return div(classes: 'adm-tuition', [
      div([
        div(classes: 'adm-tuition-title', [.text('Services provided at no direct cost to families')]),
        div(classes: 'adm-tuition-desc', [
          .text(
            'As a publicly funded program, all education, therapy, and transportation come at no cost to '
            'qualifying families.',
          ),
        ]),
      ]),
    ]);
  }

  static Component _faq() {
    // Copy supplied by the Admissions department, 2026-10-08. Note the fifth
    // item is new, and that answers 3 and 4 correct who does what: the school
    // district coordinates transport and owns the placement conversation, not
    // the school.
    const items = [
      {
        'question': 'What is the difference between EI and CPSE?',
        'answer':
            'Early Intervention (EI) serves children from birth to age 3. The School District\'s CPSE Dept. '
            '(Committee on Preschool Special Education) handles all evaluations/services from age 3 through '
            '5 years of age. We work with families every step of the way to help with the EI-CPSE transition '
            'process.',
      },
      {
        'question': 'Does my child need a diagnosis before I contact you?',
        'answer':
            "No. If you have a concern about your child's development, that's reason enough to reach out. "
            "We'll help you understand the evaluation process.",
      },
      {
        'question': 'Is transportation provided?',
        'answer':
            'Yes, for those children who are found eligible for a program placement through CPSE or CSE. '
            'Once your child is placed with us, your school district will help coordinate bus transportation '
            'to and from our program, at no cost to you.',
      },
      {
        'question': 'What if my child is already in another program?',
        'answer':
            "That's okay — we can still help to answer any questions you may have in taking the next steps. "
            "If you feel your child's current placement is not an appropriate fit, your next step would be to "
            "reach out to your school district's CPSE or CSE Departments to discuss other possible options.",
      },
      {
        'question': 'Are there any out-of-pocket costs that I need to be aware of?',
        'answer':
            'No, not at all. There are no out-of-pocket costs to you for any EI or CPSE evaluations or for '
            "your child's CPSE program placement, if found eligible.",
      },
    ];
    return div(classes: 'adm-faq', [
      h2([.text('Questions families ask')]),
      const FaqAccordion(items: items, initialOpenIndex: 1),
    ]);
  }

  static Component _ctaBand() {
    return div(classes: 'adm-cta', [
      div(classes: 'adm-cta-title', [.text('Ready to take the first step?')]),
      div(classes: 'adm-cta-actions', [
        Link(to: '/contact', classes: 'adm-cta-btn-primary', child: .text('Request Information →')),
        Link(to: '/contact', classes: 'adm-cta-btn-secondary', child: .text('Schedule a Tour')),
        a(href: 'tel:516-520-6000', classes: 'adm-cta-btn-tertiary', [.text('📞 Call 516-520-6000')]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.adm-subtitle').styles(
      maxWidth: 620.px,
      margin: .only(top: 10.px),
      color: AppColors.mutedText,
      fontSize: 1.rem,
      lineHeight: 1.55.em,
    ),

    // Eligibility — one peach card (title + checks + note), not a
    // bordered/divided box with a separate colored header bar.
    css('.adm-eligibility').styles(
      padding: .all(28.px),
      margin: .only(top: 22.px),
      radius: .all(.circular(Radii.xxl)),
      backgroundColor: AppColors.peach,
    ),
    css('.adm-eligibility-header').styles(
      margin: .only(bottom: 18.px),
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 1.25.rem,
      fontWeight: .w600,
    ),
    css('.adm-eligibility-checks').styles(
      display: .grid,
      gridTemplate: GridTemplate(
        columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))]),
      ),
      gap: .all(18.px),
    ),
    css('.adm-eligibility-check-label').styles(
      color: AppColors.navy,
      fontSize: 0.9375.rem,
      fontWeight: .w700,
    ),
    css('.adm-eligibility-check-desc').styles(
      margin: .only(top: 4.px),
      color: AppColors.mutedTextMid,
      fontSize: 0.8125.rem,
      lineHeight: 1.45.em,
    ),
    css('.adm-eligibility-note').styles(
      margin: .only(top: 18.px),
      color: AppColors.coral,
      fontSize: 0.875.rem,
      fontWeight: .w700,
    ),
    css('.adm-eligibility-note-cta').styles(
      color: AppColors.coral,
      fontWeight: .w700,
    ),

    // Enrollment journey — a 2x2 grid of cards (reference uses a photo-less
    // 4-column grid; kept as 2 columns here so each card has room for the
    // real Sanity photo, which the reference's placeholders stand in for).
    css('.adm-journey').styles(margin: .only(top: 30.px)),
    css('.adm-journey h2').styles(fontWeight: .w600),
    css('.adm-journey-steps').styles(
      display: .grid,
      margin: .only(top: 18.px),
      gridTemplate: GridTemplate(
        columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))]),
      ),
      gap: .all(16.px),
    ),
    css('.adm-journey-step').styles(
      display: .flex,
      padding: .all(20.px),
      border: .all(color: AppColors.line, width: 1.px),
      radius: .all(.circular(Radii.lg)),
      flexDirection: .column,
      alignItems: .start,
      gap: .all(12.px),
    ),
    css('.adm-journey-step-badge').styles(
      display: .flex,
      width: 36.px,
      height: 36.px,
      radius: .all(.circular(Radii.pill)),
      justifyContent: .center,
      alignItems: .center,
      color: AppColors.navyDark,
      fontWeight: .w700,
      backgroundColor: AppColors.yellow,
      raw: {'flex': 'none'},
    ),
    css('.adm-journey-step-body').styles(flex: Flex(grow: 1)),
    css('.adm-journey-step-title').styles(
      color: AppColors.navy,
      fontSize: 1.0625.rem,
      fontWeight: .w600,
    ),
    css('.adm-journey-step-desc').styles(
      margin: .only(top: 6.px),
      color: AppColors.mutedTextMid,
      fontSize: 0.8125.rem,
      lineHeight: 1.5.em,
    ),
    css('.adm-journey-step-photo').styles(width: 100.percent),
    // A ratio, not the fixed 90px this used to carry. At the 398px column
    // that height made a 4.42:1 letterbox, and three of the four photos are
    // between 1:1 and 1.5:1, so under a third of each one survived the crop.
    // A ratio also stays correct when the grid drops to one wider column on
    // mobile, where a fixed height goes squat again.
    css('.adm-journey-step-img').styles(
      display: .block,
      width: 100.percent,
      radius: .all(.circular(Radii.sm)),
      raw: {'aspect-ratio': '16 / 9', 'object-fit': 'cover'},
    ),
    // Two classes, so this beats `.photo-placeholder`'s own 140px base rule
    // and a photo-less step keeps the same shape as its siblings.
    css('.adm-journey-step-photo .photo-placeholder').styles(
      height: .auto,
      raw: {'aspect-ratio': '16 / 9'},
    ),

    // No-direct-cost callout. The leading "$0" figure this used to carry was
    // dropped — the same softening of the cost claim as Step 27.
    css('.adm-tuition').styles(
      display: .flex,
      padding: .symmetric(vertical: 24.px, horizontal: 28.px),
      margin: .only(top: 24.px),
      radius: .all(.circular(Radii.xxl)),
      alignItems: .center,
      gap: .all(20.px),
      backgroundColor: AppColors.navyDark,
    ),
    css('.adm-tuition-title').styles(
      color: Colors.white,
      fontSize: 1.125.rem,
      fontWeight: .w700,
    ),
    css('.adm-tuition-desc').styles(
      margin: .only(top: 4.px),
      color: AppColors.footerMuted,
      fontSize: 0.8125.rem,
      lineHeight: 1.45.em,
    ),

    // FAQ
    css('.adm-faq').styles(margin: .only(top: 30.px)),
    css('.adm-faq h2').styles(
      margin: .only(bottom: 12.px),
      fontWeight: .w600,
    ),

    // Big CTA band — light sky section, not a solid-color box.
    css('.adm-cta').styles(
      padding: .all(40.px),
      margin: .only(top: 28.px),
      radius: .all(.circular(Radii.xxl)),
      textAlign: .center,
      backgroundColor: AppColors.sky,
    ),
    css('.adm-cta-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 1.625.rem,
      fontWeight: .w600,
    ),
    css('.adm-cta-actions').styles(
      display: .flex,
      margin: .only(top: 20.px),
      flexWrap: .wrap,
      justifyContent: .center,
      alignItems: .center,
      gap: .all(14.px),
    ),
    css('.adm-cta-btn-primary').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 24.px),
      radius: .all(.circular(Radii.pill)),
      color: Colors.white,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 0.9375.rem,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
    ),
    css('.adm-cta-btn-secondary').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 24.px),
      border: .all(color: AppColors.line, width: 2.px),
      radius: .all(.circular(Radii.pill)),
      color: AppColors.navy,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 0.9375.rem,
      fontWeight: .w700,
      backgroundColor: Colors.white,
    ),
    css('.adm-cta-btn-tertiary').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 24.px),
      border: .all(color: AppColors.line, width: 2.px),
      radius: .all(.circular(Radii.pill)),
      color: AppColors.navy,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 0.9375.rem,
      fontWeight: .w700,
      backgroundColor: Colors.white,
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.adm-eligibility-checks').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.adm-journey-steps').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.adm-tuition').styles(flexDirection: .column, textAlign: .center),
      css('.adm-cta').styles(
        padding: .symmetric(vertical: 24.px, horizontal: 18.px),
      ),
      css('.adm-cta-title').styles(fontSize: 1.375.rem),
    ]),
  ];
}
