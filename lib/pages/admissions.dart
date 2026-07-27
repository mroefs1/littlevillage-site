import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/faq_accordion.dart';
import '../components/photo_placeholder.dart';
import '../constants/theme.dart';

class Admissions extends StatelessComponent {
  const Admissions({super.key});

  @override
  Component build(BuildContext context) {
    return ContentPage(
      breadcrumb: 'Admissions',
      title: "We'll walk you through it, step by step.",
      children: [
        p(classes: 'adm-subtitle', [
          .text(
            "Getting services for your child can feel like a maze of acronyms. It isn't, really — and you won't "
            "do it alone. Here's exactly how it works and where we fit in.",
          ),
        ]),
        _eligibility(),
        _journey(),
        _tuitionCallout(),
        _faq(),
        _ctaBand(),
      ],
    );
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

  static Component _journey() {
    const steps = [
      (
        n: '1',
        title: 'Reach out to us',
        desc:
            "Fill out the request form or call. We'll listen, answer questions, and point you to the right "
            "starting place — Early Intervention (under 3) or your district's CPSE (3+).",
      ),
      (
        n: '2',
        title: 'Evaluation & referral',
        desc:
            "A free evaluation determines your child's needs and results in an IFSP or IEP. Your county or "
            "district can refer your child to Little Village — you can request us by name.",
      ),
      (
        n: '3',
        title: 'Visit & meet the team',
        desc:
            "Tour the school, meet teachers and therapists, and see the classrooms. This is where most "
            "families feel their shoulders drop.",
      ),
      (
        n: '4',
        title: 'Placement & first day',
        desc:
            "Once placement is approved, we handle the logistics — including transportation — and welcome "
            "your child in. And we stay in touch with you every step after.",
      ),
    ];
    return div(classes: 'adm-journey', [
      h2([.text('The enrollment journey')]),
      div(classes: 'adm-journey-steps', [
        for (final step in steps)
          div(classes: 'adm-journey-step', [
            div(classes: 'adm-journey-step-badge', [.text(step.n)]),
            div(classes: 'adm-journey-step-body', [
              div(classes: 'adm-journey-step-title', [.text(step.title)]),
              div(classes: 'adm-journey-step-desc', [.text(step.desc)]),
            ]),
            div(classes: 'adm-journey-step-photo', [PhotoPlaceholder('', height: 60.px)]),
          ]),
      ]),
    ]);
  }

  static Component _tuitionCallout() {
    return div(classes: 'adm-tuition', [
      div(classes: 'adm-tuition-value', [.text('\$0')]),
      div([
        div(classes: 'adm-tuition-title', [.text('There is no tuition, ever.')]),
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
    const items = [
      {
        'question': "What's the difference between EI and CPSE?",
        'answer':
            'Early Intervention (EI) serves children from birth to age 3. CPSE (Committee on Preschool Special '
                "Education) takes over from age 3 through kindergarten entry, run through your school district. "
                'We work with families through both.',
      },
      {
        'question': 'Do I need a diagnosis before I contact you?',
        'answer':
            "No. If you have a concern about your child's development, that's reason enough to reach out. "
                "We'll help you understand the evaluation process.",
      },
      {
        'question': 'Is transportation provided?',
        'answer':
            'Yes. Once your child is placed with us, we coordinate transportation to and from school at no '
                'cost to your family.',
      },
      {
        'question': 'What if my child is already in another program?',
        'answer':
            "That's okay — we can still help. Reach out and we'll talk through your options, including "
                'whether a transfer makes sense for your child.',
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
      div(classes: 'adm-cta-subtitle', [.text('We respond to every family within one business day.')]),
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
      color: AppColors.body,
      fontSize: 15.px,
      lineHeight: 1.55.em,
    ),

    // Eligibility
    css('.adm-eligibility').styles(
      margin: .only(top: 22.px),
      border: .all(color: AppColors.borderMedium, width: 2.px),
      radius: .all(.circular(10.px)),
      overflow: .hidden,
    ),
    css('.adm-eligibility-header').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 20.px),
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 19.px,
      fontWeight: .w700,
      backgroundColor: AppColors.lightBlueTint,
    ),
    css('.adm-eligibility-checks').styles(display: .flex),
    css('.adm-eligibility-check', [
      css('&').styles(
        padding: .symmetric(vertical: 16.px, horizontal: 20.px),
        border: .only(right: .solid(color: AppColors.borderLight, width: 1.5.px)),
        flex: Flex(grow: 1),
      ),
      css('&:last-child').styles(border: .none),
    ]),
    css('.adm-eligibility-check-label').styles(
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 15.px,
      fontWeight: .w700,
    ),
    css('.adm-eligibility-check-desc').styles(
      margin: .only(top: 4.px),
      color: AppColors.body,
      fontSize: 13.px,
      lineHeight: 1.45.em,
    ),
    css('.adm-eligibility-note').styles(
      padding: .symmetric(vertical: 12.px, horizontal: 20.px),
      color: AppColors.body,
      fontSize: 13.px,
      backgroundColor: AppColors.shadedBg,
    ),
    css('.adm-eligibility-note-cta').styles(
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontWeight: .w700,
    ),

    // Enrollment journey
    css('.adm-journey').styles(margin: .only(top: 30.px)),
    css('.adm-journey-steps').styles(display: .flex, margin: .only(top: 18.px), flexDirection: .column, gap: .all(14.px)),
    css('.adm-journey-step').styles(
      display: .flex,
      padding: .symmetric(vertical: 16.px, horizontal: 18.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
      alignItems: .start,
      gap: .all(16.px),
    ),
    css('.adm-journey-step-badge').styles(
      display: .flex,
      width: 40.px,
      height: 40.px,
      radius: .all(.circular(20.px)),
      justifyContent: .center,
      alignItems: .center,
      color: Colors.white,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 20.px,
      fontWeight: .w700,
      backgroundColor: AppColors.primary,
      raw: {'flex': 'none'},
    ),
    css('.adm-journey-step-body').styles(flex: Flex(grow: 1)),
    css('.adm-journey-step-title').styles(
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 18.px,
      fontWeight: .w700,
    ),
    css('.adm-journey-step-desc').styles(
      margin: .only(top: 3.px),
      color: AppColors.body,
      fontSize: 13.px,
      lineHeight: 1.5.em,
    ),
    css('.adm-journey-step-photo').styles(width: 90.px, raw: {'flex': 'none'}),

    // $0 tuition callout
    css('.adm-tuition').styles(
      display: .flex,
      padding: .symmetric(vertical: 20.px, horizontal: 24.px),
      margin: .only(top: 24.px),
      border: .all(color: AppColors.utilityBorder, width: 2.px),
      radius: .all(.circular(10.px)),
      alignItems: .center,
      gap: .all(18.px),
      backgroundColor: AppColors.lightBlueTint,
    ),
    css('.adm-tuition-value').styles(
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 40.px,
      fontWeight: .w700,
      raw: {'flex': 'none'},
    ),
    css('.adm-tuition-title').styles(
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 19.px,
      fontWeight: .w700,
    ),
    css('.adm-tuition-desc').styles(
      margin: .only(top: 3.px),
      color: AppColors.body,
      fontSize: 13.px,
      lineHeight: 1.45.em,
    ),

    // FAQ
    css('.adm-faq').styles(margin: .only(top: 30.px)),
    css('.adm-faq h2').styles(margin: .only(bottom: 12.px)),

    // Big CTA band
    css('.adm-cta').styles(
      padding: .all(30.px),
      margin: .only(top: 28.px),
      radius: .all(.circular(12.px)),
      textAlign: .center,
      backgroundColor: AppColors.primary,
    ),
    css('.adm-cta-title').styles(
      color: Colors.white,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 28.px,
      fontWeight: .w700,
    ),
    css('.adm-cta-subtitle').styles(margin: .only(top: 6.px), color: AppColors.pillTint, fontSize: 14.px),
    css('.adm-cta-actions').styles(
      display: .flex,
      margin: .only(top: 20.px),
      flexWrap: .wrap,
      justifyContent: .center,
      alignItems: .center,
      gap: .all(14.px),
    ),
    css('.adm-cta-btn-primary').styles(
      padding: .symmetric(vertical: 14.px, horizontal: 28.px),
      radius: .all(.circular(9.px)),
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 18.px,
      fontWeight: .w700,
      backgroundColor: Colors.white,
    ),
    css('.adm-cta-btn-secondary').styles(
      padding: .symmetric(vertical: 12.px, horizontal: 26.px),
      border: .all(color: Colors.white, width: 2.px),
      radius: .all(.circular(9.px)),
      color: Colors.white,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 18.px,
      fontWeight: .w700,
    ),
    css('.adm-cta-btn-tertiary').styles(
      padding: .symmetric(vertical: 12.px, horizontal: 26.px),
      border: .all(color: AppColors.utilityBorder, width: 2.px),
      radius: .all(.circular(9.px)),
      color: Colors.white,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 18.px,
      fontWeight: .w700,
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.adm-eligibility-checks').styles(flexDirection: .column),
      css('.adm-eligibility-check').styles(
        border: .only(right: .none(), bottom: .solid(color: AppColors.borderLight, width: 1.5.px)),
      ),
      css('.adm-eligibility-check:last-child').styles(border: .none),
      css('.adm-journey-step').styles(flexWrap: .wrap),
      css('.adm-journey-step-photo').styles(display: .none),
      css('.adm-tuition').styles(flexDirection: .column, textAlign: .center),
      css('.adm-cta').styles(padding: .symmetric(vertical: 24.px, horizontal: 18.px)),
      css('.adm-cta-title').styles(fontSize: 22.px),
    ]),
  ];
}
