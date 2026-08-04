import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/content_page.dart';
import '../components/cta_band.dart';
import '../components/photo_placeholder.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/page_content.dart';
import '../sanity/models/person.dart';

// The redesign drops the old link-grid hub; Mission/History/Founders/
// Facilities/Staff/Board stay reachable via the compact `_subNav` row instead
// (decided with the user rather than assumed, since CLAUDE.md flagged it as
// an open item). Mission copy is still sourced from the Sanity `page` doc
// (slug "about") — only the hardcoded stats/headline/accreditation copy is
// design-specified marketing text with no Sanity home.
class About extends AsyncStatelessComponent {
  const About({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final page = await contentRepository.getPage('about');
    final staff = await contentRepository.getStaffMembers();

    return .fragment([
      const SeoMeta(
        title: 'About Us | $siteName',
        description:
            'Hagedorn Little Village School, part of the Jack Joel Center for Special Children, has served '
            'Long Island families with developmental delays and disabilities since 1953.',
        path: '/about',
      ),
      ContentPage(
        breadcrumb: 'About',
        title: '50+ years of meeting every child where they are.',
        children: [
          p(classes: 'about-subtitle', [
            .text(
              'Hagedorn Little Village School, part of the Jack Joel Center for Special Children, has served '
              'Long Island families with developmental delays and disabilities since 1953.',
            ),
          ]),
          _subNav(),
          _stats(),
          _mission(page),
          if (staff.isNotEmpty) _team(staff.take(3).toList()),
          _accreditation(),
          const CtaBand(),
        ],
      ),
    ]);
  }

  static Component _subNav() {
    const links = [
      (label: 'Mission', path: '/mission'),
      (label: 'History', path: '/history'),
      (label: 'Founders', path: '/founders'),
      (label: 'Facilities', path: '/facilities'),
      (label: 'Admin Staff', path: '/staff'),
      (label: 'Board Members', path: '/board'),
    ];
    return div(classes: 'about-subnav', [
      for (final link in links) Link(to: link.path, child: .text(link.label)),
    ]);
  }

  static Component _stats() {
    const stats = [
      (value: '1953', label: 'founded'),
      (value: '50+', label: 'years serving Long Island'),
      (value: 'Birth–12', label: 'EI → Elementary'),
      (value: '\$0', label: 'cost to families'),
    ];
    return div(classes: 'about-stats', [
      for (final stat in stats)
        div(classes: 'about-stat', [
          div(classes: 'about-stat-value', [.text(stat.value)]),
          div(classes: 'about-stat-label', [.text(stat.label)]),
        ]),
    ]);
  }

  static Component _mission(PageContent? page) {
    final body = page?.body;
    return div(classes: 'about-mission', [
      div(classes: 'about-mission-text', [
        h2([.text('Our mission')]),
        if (body != null && !body.isEmpty)
          PortableTextView(body)
        else
          p([
            .text(
              'We believe every child deserves an education built around who they are, not a label. Our '
              'teachers and therapists work as one team, in one building, so children get consistent support '
              'without being shuttled between providers.',
            ),
          ]),
      ]),
      div(classes: 'about-mission-photo', [
        if (page?.heroImageUrl != null)
          img(src: page!.heroImageUrl!, alt: 'Campus photo', classes: 'about-mission-img')
        else
          const PhotoPlaceholder('photo — campus exterior or classroom wide shot'),
      ]),
    ]);
  }

  static Component _team(List<StaffMember> members) {
    return div(classes: 'about-team', [
      h2([.text('Meet the team')]),
      div(classes: 'about-team-cards', [
        for (final member in members)
          div(classes: 'about-team-card', [
            if (member.photoUrl != null)
              img(src: member.photoUrl!, alt: 'Staff photo', classes: 'about-team-photo')
            else
              div(classes: 'about-team-photo-placeholder', []),
            div(classes: 'about-team-name', [.text(member.name)]),
            div(classes: 'about-team-title', [.text(member.title)]),
          ]),
      ]),
    ]);
  }

  static Component _accreditation() {
    return div(classes: 'about-accreditation', [
      div(classes: 'about-accreditation-title', [.text('Approved & accredited')]),
      div(classes: 'about-accreditation-body', [
        .text(
          'Approved by the New York State Education Department as a preschool and school-age special education '
          'provider, and by NY Early Intervention as an approved EI agency.',
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.about-subtitle').styles(
      maxWidth: 640.px,
      margin: .only(top: 10.px),
      color: AppColors.body,
      fontSize: 15.px,
      lineHeight: 1.55.em,
    ),

    // Sub-nav
    css('.about-subnav', [
      css('&').styles(
        display: .flex,
        margin: .only(top: 18.px),
        flexWrap: .wrap,
        gap: .all(18.px),
      ),
      css('a').styles(
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
        fontWeight: .w700,
      ),
    ]),

    // Stat strip
    css('.about-stats').styles(
      display: .flex,
      margin: .only(top: 18.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
      overflow: .hidden,
    ),
    css('.about-stat').styles(
      padding: .all(16.px),
      border: .only(
        right: .solid(color: AppColors.borderLight, width: 1.5.px),
      ),
      flex: Flex(grow: 1),
      textAlign: .center,
    ),
    css('.about-stat:last-child').styles(border: .none),
    css('.about-stat-value').styles(
      color: AppColors.primary,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 24.px,
      fontWeight: .w700,
    ),
    css('.about-stat-label').styles(color: AppColors.body, fontSize: 12.px),

    // Mission
    css('.about-mission').styles(
      display: .flex,
      margin: .only(top: 30.px),
      alignItems: .center,
      gap: .all(26.px),
    ),
    css('.about-mission-text').styles(flex: Flex(grow: 1)),
    css('.about-mission-text h2').styles(margin: .zero),
    css('.about-mission-text .body-content').styles(
      maxWidth: 480.px,
      margin: .only(top: 10.px),
    ),
    css('.about-mission-photo').styles(flex: Flex(grow: 1)),
    css('.about-mission-photo .photo-placeholder').styles(height: 200.px),
    css('.about-mission-img').styles(
      display: .block,
      width: 100.percent,
      height: 200.px,
      radius: .all(.circular(10.px)),
      raw: {'object-fit': 'cover'},
    ),

    // Team teaser
    css('.about-team').styles(margin: .only(top: 26.px)),
    css('.about-team h2').styles(
      margin: .only(bottom: 14.px),
      fontSize: 22.px,
    ),
    css('.about-team-cards').styles(display: .flex, gap: .all(16.px)),
    css('.about-team-card').styles(
      padding: .all(14.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
      flex: Flex(grow: 1),
      textAlign: .center,
      backgroundColor: Colors.white,
    ),
    css('.about-team-photo').styles(
      width: 72.px,
      height: 72.px,
      margin: .only(bottom: 10.px),
      radius: .all(.circular(36.px)),
      raw: {'object-fit': 'cover', 'margin-left': 'auto', 'margin-right': 'auto'},
    ),
    css('.about-team-photo-placeholder').styles(
      width: 72.px,
      height: 72.px,
      margin: .only(bottom: 10.px),
      border: .all(color: AppColors.placeholderBorder, width: 2.px, style: .dashed),
      radius: .all(.circular(36.px)),
      raw: {
        'margin-left': 'auto',
        'margin-right': 'auto',
        'background-image':
            'repeating-linear-gradient(45deg, ${AppColors.borderLight.value}, ${AppColors.borderLight.value} 8px, ${AppColors.placeholderStripe.value} 8px, ${AppColors.placeholderStripe.value} 16px)',
      },
    ),
    css('.about-team-name').styles(
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 15.px,
      fontWeight: .w700,
    ),
    css('.about-team-title').styles(color: AppColors.muted, fontSize: 12.px),

    // Accreditation strip
    css('.about-accreditation').styles(
      padding: .symmetric(vertical: 16.px, horizontal: 22.px),
      margin: .only(top: 18.px),
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(10.px)),
      backgroundColor: AppColors.shadedBg,
    ),
    css('.about-accreditation-title').styles(
      margin: .only(bottom: 8.px),
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 16.px,
      fontWeight: .w700,
    ),
    css('.about-accreditation-body').styles(color: AppColors.body, fontSize: 13.px, lineHeight: 1.5.em),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.about-stats').styles(flexWrap: .wrap),
      css('.about-stat').styles(
        minWidth: 50.percent,
        border: .only(right: .none(), bottom: .solid(color: AppColors.borderLight, width: 1.5.px)),
      ),
      css('.about-mission').styles(flexDirection: .column),
      css('.about-mission-photo .photo-placeholder').styles(height: 160.px),
      css('.about-mission-img').styles(height: 160.px),
      css('.about-team-cards').styles(flexDirection: .column),
    ]),
  ];
}
