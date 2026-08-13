import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/content_page.dart';
import '../components/photo_placeholder.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';

class SupportUs extends AsyncStatelessComponent {
  const SupportUs({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final siteSettings = await contentRepository.getSiteSettings();

    return .fragment([
      const SeoMeta(
        title: 'Support Us | $siteName',
        description:
            'Support Hagedorn Little Village School — give online, by mail, or through a planned or tribute gift.',
        path: '/support-us',
      ),
      ContentPage(
        breadcrumb: 'Support Us',
        title: 'Support Little Village.',
        children: [
          p(classes: 'su-subtitle', [
            .text(
              'Your gift helps us provide life-changing early intervention, preschool, and school-age programs '
              'to children with disabilities — tuition-free. Thank you for your support.',
            ),
          ]),
          _giving(siteSettings.donateUrl),
          _brick(),
          _moreWays(siteSettings.donateUrl),
          _contact(),
        ],
      ),
    ]);
  }

  static Component _giving(String? donateUrl) {
    return div(classes: 'su-giving-grid', [
      div(classes: 'su-online-card', [
        div(classes: 'su-online-title', [.text('Make a gift online')]),
        p(classes: 'su-online-desc', [
          .text(
            'Give a one-time or recurring donation securely through our GiveLively giving page. Every dollar '
            'goes directly to supporting our students.',
          ),
        ]),
        if (donateUrl != null)
          a(href: donateUrl, target: Target.blank, classes: 'su-online-cta', [.text('♥ Donate on GiveLively →')])
        else
          span(classes: 'su-online-cta', [.text('♥ Donate on GiveLively →')]),
      ]),
      div(classes: 'su-mail-card', [
        div(classes: 'su-mail-title', [.text('Give by mail')]),
        p(classes: 'su-mail-desc', [
          .text('Prefer to mail a check? Please make it payable to Hagedorn Little Village School and send to:'),
        ]),
        div(classes: 'su-mail-address', [
          strong([.text('The Hagedorn Little Village School')]),
          br(),
          .text('750 Hicksville Road'),
          br(),
          .text('Seaford, NY 11783'),
        ]),
      ]),
    ]);
  }

  static Component _brick() {
    return div(classes: 'su-brick', [
      div(classes: 'su-brick-body', [
        div(classes: 'su-brick-title', [.text('Help build the pathway to the future')]),
        p(classes: 'su-brick-desc', [
          .text(
            'Purchase a commemorative brick and leave a lasting mark on our campus. Each engraved brick will be '
            'placed along our new walking pathway — a tribute from your family, in honor of a loved one, or in '
            'celebration of a milestone.',
          ),
        ]),
        // No brick-purchase link/process exists yet — styled as a CTA but
        // deliberately left as an inert `span`, not a link, until one does.
        span(classes: 'su-brick-cta', [.text('Purchase a brick →')]),
      ]),
      PhotoPlaceholder('brick photo placeholder', height: 120.px),
    ]);
  }

  static Component _moreWays(String? donateUrl) {
    return div(classes: 'su-more-grid', [
      div(classes: 'su-planned-card', [
        div(classes: 'su-planned-title', [.text('Planned Giving')]),
        p(classes: 'su-planned-desc', [
          .text(
            'Give a gift of stock or make a wire transfer to support our students. Speak with your financial '
            'advisor about how a planned gift can benefit you and Little Village.',
          ),
        ]),
        p(classes: 'su-planned-note', [.text('Contact our fundraising department to learn more.')]),
      ]),
      div(classes: 'su-tribute-card', [
        div(classes: 'su-tribute-title', [.text('Gifts in Honor or Memory of a Loved One')]),
        p(classes: 'su-tribute-desc', [
          .text('Celebrate a milestone or honor someone special with a tribute gift made in their name.'),
        ]),
        if (donateUrl != null)
          a(href: donateUrl, target: Target.blank, classes: 'su-tribute-cta', [.text('Make a tribute gift →')])
        else
          span(classes: 'su-tribute-cta', [.text('Make a tribute gift →')]),
      ]),
    ]);
  }

  static Component _contact() {
    return div(classes: 'su-contact', [
      div(classes: 'su-contact-title', [.text('Questions about giving?')]),
      p(classes: 'su-contact-desc', [
        .text(
          "Contact our fundraising office — we're happy to talk through options, including matching gifts and "
          'planned giving.',
        ),
      ]),
      p(classes: 'su-contact-name', [
        .text('Jennifer Kirincic, Director of Fundraising'),
        br(),
        span(classes: 'su-contact-details', [.text('516-520-6043 · jennifer.kirincic@littlevillage.org')]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.su-subtitle').styles(
      maxWidth: 620.px,
      margin: .only(top: 10.px),
      color: AppColors.mutedText,
      fontSize: 16.px,
      lineHeight: 1.55.em,
    ),

    // "Make a gift online" (peach) + "Give by mail" (offWhite) two-column band.
    css('.su-giving-grid').styles(
      display: .grid,
      margin: .only(top: 28.px),
      gridTemplate: GridTemplate(
        columns: GridTracks([GridTrack(TrackSize.fr(1.3)), GridTrack(TrackSize.fr(0.7))]),
      ),
      gap: .all(24.px),
    ),
    css('.su-online-card').styles(
      display: .flex,
      padding: .all(40.px),
      radius: .all(.circular(Radii.xxl)),
      flexDirection: .column,
      justifyContent: .center,
      gap: .all(16.px),
      backgroundColor: AppColors.peach,
    ),
    css('.su-online-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 24.px,
      fontWeight: .w600,
    ),
    css('.su-online-desc').styles(
      maxWidth: 480.px,
      color: AppColors.mutedText,
      fontSize: 15.px,
      lineHeight: 1.5.em,
    ),
    css('.su-online-cta').styles(
      display: .inlineBlock,
      padding: .symmetric(vertical: 14.px, horizontal: 28.px),
      margin: .only(top: 8.px),
      radius: .all(.circular(Radii.pill)),
      color: Colors.white,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
      raw: {'width': 'fit-content'},
    ),
    css('.su-mail-card').styles(
      display: .flex,
      padding: .all(32.px),
      border: .all(color: AppColors.line, width: 1.px),
      radius: .all(.circular(Radii.xxl)),
      flexDirection: .column,
      gap: .all(14.px),
      backgroundColor: AppColors.offWhite,
    ),
    css('.su-mail-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 19.px,
      fontWeight: .w600,
    ),
    css('.su-mail-desc').styles(
      color: AppColors.mutedText,
      fontSize: 15.px,
      lineHeight: 1.5.em,
    ),
    css('.su-mail-address').styles(
      padding: .symmetric(vertical: 16.px, horizontal: 18.px),
      border: .all(color: AppColors.line, width: 1.px),
      radius: .all(.circular(Radii.md)),
      color: AppColors.navy,
      fontSize: 15.px,
      lineHeight: 1.5.em,
      backgroundColor: Colors.white,
    ),

    // Brick campaign band.
    css('.su-brick').styles(
      display: .grid,
      padding: .all(48.px),
      margin: .only(top: 24.px),
      radius: .all(.circular(Radii.xxl)),
      alignItems: .center,
      gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.auto)])),
      gap: .all(32.px),
      backgroundColor: AppColors.sky,
    ),
    css('.su-brick-body').styles(
      display: .flex,
      flexDirection: .column,
      gap: .all(14.px),
    ),
    css('.su-brick-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 26.px,
      fontWeight: .w600,
      letterSpacing: (-0.01).em,
    ),
    css('.su-brick-desc').styles(
      maxWidth: 560.px,
      color: AppColors.mutedText,
      fontSize: 15.px,
      lineHeight: 1.5.em,
    ),
    css('.su-brick-cta').styles(
      display: .inlineBlock,
      padding: .symmetric(vertical: 14.px, horizontal: 28.px),
      margin: .only(top: 6.px),
      radius: .all(.circular(Radii.pill)),
      cursor: .defaultCursor,
      color: Colors.white,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 15.px,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
      raw: {'width': 'fit-content'},
    ),

    // Planned Giving (mint) + Tribute Gift (peachDark) two-column band.
    css('.su-more-grid').styles(
      display: .grid,
      margin: .only(top: 24.px),
      gridTemplate: GridTemplate(
        columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))]),
      ),
      gap: .all(24.px),
    ),
    css('.su-planned-card').styles(
      display: .flex,
      padding: .all(32.px),
      radius: .all(.circular(Radii.xxl)),
      flexDirection: .column,
      gap: .all(14.px),
      backgroundColor: AppColors.mint,
    ),
    css('.su-planned-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 21.px,
      fontWeight: .w600,
    ),
    css('.su-planned-desc').styles(
      color: AppColors.mutedText,
      fontSize: 15.px,
      lineHeight: 1.5.em,
    ),
    css('.su-planned-note').styles(
      color: AppColors.navy,
      fontSize: 15.px,
      fontWeight: .w600,
    ),
    css('.su-tribute-card').styles(
      display: .flex,
      padding: .all(32.px),
      radius: .all(.circular(Radii.xxl)),
      flexDirection: .column,
      gap: .all(14.px),
      backgroundColor: AppColors.peachDark,
    ),
    css('.su-tribute-title').styles(
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 21.px,
      fontWeight: .w600,
    ),
    css('.su-tribute-desc').styles(
      color: AppColors.mutedText,
      fontSize: 15.px,
      lineHeight: 1.5.em,
    ),
    css('.su-tribute-cta').styles(
      display: .inlineBlock,
      padding: .symmetric(vertical: 12.px, horizontal: 22.px),
      margin: .only(top: 4.px),
      radius: .all(.circular(Radii.pill)),
      color: Colors.white,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 14.px,
      fontWeight: .w700,
      backgroundColor: AppColors.coral,
      raw: {'width': 'fit-content'},
    ),

    // Closing fundraising-contact section.
    css('.su-contact').styles(
      padding: .only(top: 8.px, bottom: 24.px),
      margin: .only(top: 24.px),
      textAlign: .center,
    ),
    css('.su-contact-title').styles(
      margin: .only(bottom: 8.px),
      color: AppColors.navy,
      fontFamily: .list([headingFontFamily, FontFamilies.serif]),
      fontSize: 21.px,
      fontWeight: .w600,
    ),
    css('.su-contact-desc').styles(
      margin: .only(bottom: 16.px),
      color: AppColors.mutedText,
      fontSize: 15.px,
    ),
    css('.su-contact-name').styles(
      color: AppColors.navy,
      fontSize: 15.px,
      fontWeight: .w600,
    ),
    css('.su-contact-details').styles(
      color: AppColors.mutedText,
      fontWeight: .w400,
    ),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.su-giving-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.su-brick').styles(
        padding: .symmetric(vertical: 28.px, horizontal: 22.px),
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
      css('.su-more-grid').styles(
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
      ),
    ]),
  ];
}
