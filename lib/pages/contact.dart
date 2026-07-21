import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/photo_placeholder.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/site_settings.dart';

// Full redesign per the design handoff (contact.html): a request-info form
// alongside a reachability info card, replacing the old generic
// ContentPage + PortableTextView body. Only the phone/email come from
// Sanity (`SiteSettings`, otherwise unused so far) — the rest of the copy
// is static, matching how Admissions was implemented.
class Contact extends AsyncStatelessComponent {
  const Contact({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final siteSettings = await contentRepository.getSiteSettings();

    return ContentPage(
      breadcrumb: 'Contact',
      title: "Let's talk about your child.",
      children: [
        p(classes: 'contact-subtitle', [
          .text(
            "Whether you have a question, want to request information, or you're ready to schedule a tour — "
            "reach out and we'll respond within one business day.",
          ),
        ]),
        div(classes: 'contact-grid', [
          _form(),
          _infoColumn(siteSettings),
        ]),
      ],
    );
  }

  static Component _form() {
    return div(classes: 'contact-form-card', [
      div(classes: 'contact-form-title', [.text('Request Information')]),
      form(classes: 'contact-form-grid', [
        _field('Parent / guardian name', child: const input(type: InputType.text), full: true),
        _field("Child's date of birth", child: const input(type: InputType.date)),
        _field('County / school district (if known)', child: const input(type: InputType.text)),
        _field('Phone', child: const input(type: InputType.tel)),
        _field('Email', child: const input(type: InputType.email)),
        _field(
          'What would you like us to know?',
          child: const textarea(rows: 4, []),
          full: true,
        ),
        div(classes: 'contact-form-actions', [
          button(type: ButtonType.button, classes: 'contact-btn-primary', [.text('Send request →')]),
          button(type: ButtonType.button, classes: 'contact-btn-secondary', [.text('Schedule a Tour instead')]),
        ]),
      ]),
    ]);
  }

  static Component _field(String labelText, {required Component child, bool full = false}) {
    return label(classes: full ? 'contact-field contact-field-full' : 'contact-field', [
      div(classes: 'contact-field-label', [.text(labelText)]),
      child,
    ]);
  }

  static Component _infoColumn(SiteSettings siteSettings) {
    return div(classes: 'contact-info-column', [
      div(classes: 'contact-info-card', [
        _infoRow('📞 Phone', siteSettings.phone ?? '516-520-6000'),
        _infoRow('✉ Email', siteSettings.email ?? 'information@littlevillage.org'),
        _infoRow('📍 Address', 'Seaford, NY'),
        _infoRow('🕐 Office hours', 'Mon–Fri, 8:30 AM – 4:00 PM'),
      ]),
      PhotoPlaceholder('map placeholder', height: 140.px),
    ]);
  }

  static Component _infoRow(String label, String value) {
    return div(classes: 'contact-info-row', [
      div(classes: 'contact-info-label', [.text(label)]),
      div(classes: 'contact-info-value', [.text(value)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact-subtitle').styles(
      maxWidth: 640.px,
      margin: .only(top: 10.px),
      color: AppColors.body,
      fontSize: 15.px,
      lineHeight: 1.55.em,
    ),
    css('.contact-grid').styles(
      display: .flex,
      margin: .only(top: 20.px),
      alignItems: .start,
      gap: .all(26.px),
    ),

    // Form card
    css('.contact-form-card').styles(
      padding: .all(22.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
      flex: Flex(grow: 1.3),
    ),
    css('.contact-form-title').styles(
      margin: .only(bottom: 14.px),
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 19.px,
      fontWeight: .w700,
    ),
    css('.contact-form-grid').styles(
      display: .grid,
      gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))])),
      gap: .all(12.px),
    ),
    css('.contact-field').styles(display: .flex, flexDirection: .column, gap: .all(4.px)),
    css('.contact-field-full').styles(gridPlacement: GridPlacement(columnStart: LinePlacement.span(2))),
    css('.contact-field-label').styles(color: AppColors.body, fontSize: 12.px),
    css('.contact-field input, .contact-field textarea', [
      css('&').styles(
        width: 100.percent,
        padding: .symmetric(vertical: 9.px, horizontal: 10.px),
        border: .all(color: AppColors.borderMedium, width: 1.5.px),
        radius: .all(.circular(7.px)),
        color: AppColors.ink,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 14.px,
        backgroundColor: Color('#fbfaf8'),
        raw: {'box-sizing': 'border-box'},
      ),
      css('&:focus').styles(
        outline: Outline(color: AppColors.primary, width: OutlineWidth(1.5.px), style: .solid),
        raw: {'outline-offset': '1px'},
      ),
    ]),
    css('.contact-field textarea').styles(raw: {'resize': 'vertical'}),
    css('.contact-form-actions').styles(
      display: .flex,
      margin: .only(top: 4.px),
      gap: .all(12.px),
      gridPlacement: GridPlacement(columnStart: LinePlacement.span(2)),
    ),
    css('.contact-btn-primary').styles(
      padding: .symmetric(vertical: 12.px, horizontal: 22.px),
      border: .none,
      radius: .all(.circular(9.px)),
      color: Colors.white,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 16.px,
      fontWeight: .w700,
      backgroundColor: AppColors.primary,
      raw: {'cursor': 'pointer'},
    ),
    css('.contact-btn-secondary').styles(
      padding: .symmetric(vertical: 10.px, horizontal: 20.px),
      border: .all(color: AppColors.primary, width: 2.px),
      radius: .all(.circular(9.px)),
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 16.px,
      fontWeight: .w700,
      backgroundColor: Colors.white,
      raw: {'cursor': 'pointer'},
    ),

    // Info column
    css('.contact-info-column').styles(display: .flex, flexDirection: .column, gap: .all(14.px), flex: Flex(grow: 1)),
    css('.contact-info-card').styles(
      padding: .all(18.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
    ),
    css('.contact-info-row').styles(margin: .only(top: 12.px)),
    css('.contact-info-row:first-child').styles(margin: .zero),
    css('.contact-info-label').styles(
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 16.px,
      fontWeight: .w700,
    ),
    css('.contact-info-value').styles(margin: .only(top: 4.px), color: AppColors.body, fontSize: 14.px),
  ];
}
