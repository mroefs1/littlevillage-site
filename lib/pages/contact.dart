import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/contact_form.dart';
import '../components/content_page.dart';
import '../components/photo_placeholder.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
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

    return .fragment([
      const SeoMeta(
        title: 'Contact | $siteName',
        description:
            "Whether you have a question, want to request information, or you're ready to schedule a tour — "
            "reach out and we'll be in touch soon.",
        path: '/contact',
      ),
      ContentPage(
        breadcrumb: 'Contact',
        title: "Let's talk about your child.",
        children: [
          p(classes: 'contact-subtitle', [
            .text(
              "Whether you have a question, want to request information, or you're ready to schedule a tour — "
              "reach out and we'll be in touch soon.",
            ),
          ]),
          div(classes: 'contact-grid', [
            _form(),
            _infoColumn(siteSettings),
          ]),
        ],
      ),
    ]);
  }

  static Component _form() {
    return div(classes: 'contact-form-card', [
      div(classes: 'contact-form-title', [.text('Request Information')]),
      div(classes: 'contact-form-legend', [
        span(classes: 'contact-required-mark', attributes: {'aria-hidden': 'true'}, [.text('*')]),
        .text(' Required'),
      ]),
      const ContactForm(),
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
      maxWidth: 620.px,
      margin: .only(top: 10.px),
      color: AppColors.mutedText,
      fontSize: 16.px,
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
      padding: .all(28.px),
      border: .all(color: AppColors.line, width: 1.px),
      radius: .all(.circular(Radii.xxl)),
      flex: Flex(grow: 1.3),
      backgroundColor: AppColors.offWhite,
    ),
    css('.contact-form-title').styles(
      margin: .only(bottom: 4.px),
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 19.px,
      fontWeight: .w600,
    ),
    css('.contact-form-legend').styles(
      margin: .only(bottom: 16.px),
      color: AppColors.mutedTextLight,
      fontSize: 13.px,
    ),
    css('.contact-form-grid').styles(
      display: .grid,
      gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))])),
      gap: .all(16.px),
    ),
    css('.contact-field').styles(display: .flex, flexDirection: .column, gap: .all(4.px)),
    css('.contact-field-full').styles(gridPlacement: GridPlacement(columnStart: LinePlacement.span(2))),
    css('.contact-field-label').styles(color: AppColors.navy, fontSize: 13.px, fontWeight: .w600),
    css('.contact-field input, .contact-field textarea, .contact-field select', [
      css('&').styles(
        width: 100.percent,
        padding: .symmetric(vertical: 10.px, horizontal: 12.px),
        border: .all(color: AppColors.lineDark, width: 1.px),
        radius: .all(.circular(Radii.sm)),
        color: AppColors.navy,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 14.px,
        backgroundColor: Colors.white,
        raw: {'box-sizing': 'border-box'},
      ),
      css('&:focus').styles(
        outline: Outline(color: AppColors.blue, width: OutlineWidth(1.5.px), style: .solid),
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
      padding: .symmetric(vertical: 14.px, horizontal: 24.px),
      border: .none,
      radius: .all(.circular(Radii.pill)),
      color: Colors.white,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
      raw: {'cursor': 'pointer'},
    ),
    // Info column — plain gap-stacked rows, not a bordered/padded card.
    css('.contact-info-column').styles(display: .flex, flexDirection: .column, gap: .all(14.px), flex: Flex(grow: 1)),
    css('.contact-info-card').styles(display: .flex, flexDirection: .column, gap: .all(16.px)),
    css('.contact-info-label').styles(color: AppColors.mutedTextLight, fontSize: 13.px),
    css('.contact-info-value').styles(
      margin: .only(top: 4.px),
      color: AppColors.navy,
      fontSize: 15.px,
      fontWeight: .w700,
    ),
    // Map placeholder: sky-toned stripes for this spot specifically.
    // `photo_placeholder.dart`'s shared default (peach stripes) is for
    // photo-shaped content elsewhere and stays untouched — this overrides
    // just this page's instance via a more specific selector.
    css('.contact-info-column .photo-placeholder').styles(
      height: 200.px,
      radius: .all(.circular(Radii.lg)),
      color: AppColors.mutedTextLight,
      raw: {
        'background-image':
            'repeating-linear-gradient(135deg, ${AppColors.sky.value}, ${AppColors.sky.value} 10px, ${AppColors.line.value} 10px, ${AppColors.line.value} 20px)',
      },
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.contact-grid').styles(flexDirection: .column),
      css('.contact-form-card').styles(padding: .all(18.px)),
      css('.contact-form-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.contact-field-full').styles(gridPlacement: GridPlacement(columnStart: LinePlacement.span(1))),
      css('.contact-form-actions').styles(
        flexDirection: .column,
        gridPlacement: GridPlacement(columnStart: LinePlacement.span(1)),
      ),
      css('.contact-form-actions button').styles(width: 100.percent),
    ]),
  ];
}
