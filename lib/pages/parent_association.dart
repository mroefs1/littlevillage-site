import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/collection_card.dart';
import '../components/content_page.dart';
import '../components/portable_text_view.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../constants/theme.dart';
import '../sanity/content_repository.dart';
import '../sanity/models/pa_event_item.dart';
import '../sanity/models/parent_association.dart';
import '../util/date_format.dart';

// Content (intro, dues, signup link, board members, contacts, PA events) is
// fully Sanity-backed via the `parentAssociation` singleton and the
// `pa_event` type, matching Current Families/About's visual style
// (ContentPage shell, same section/card conventions).
class ParentAssociation extends AsyncStatelessComponent {
  const ParentAssociation({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final info = await contentRepository.getParentAssociationInfo();
    final paEvents = await contentRepository.getPaEvents();

    return .fragment([
      const SeoMeta(
        title: 'Parent Association | $siteName',
        description:
            'The HLVS Parent Association brings families together to get involved in their child\'s school — '
            'meetings, membership, and how to reach the board.',
        path: '/parent-association',
      ),
      ContentPage(
        breadcrumb: 'Parent Association',
        title: 'Parent Association',
        children: [
          // `.detail-container` (defined in content_page.dart, already used by
          // News/Event detail pages) centers the body in a narrower column
          // instead of stretching full-width like the plain `.page` shell —
          // reads better for this page's mix of prose, cards, and lists.
          div(classes: 'detail-container', [
            if (info != null) ...[
              if (!info.intro.isEmpty) PortableTextView(info.intro),
              _duesLine(info),
              _signupCta(info),
              if (info.boardMembers.isNotEmpty) _boardMembers(info),
              if (info.contacts.isNotEmpty) _contacts(info),
            ] else
              p([.text('Parent Association details are coming soon.')]),
            _paEvents(paEvents),
          ]),
        ],
      ),
    ]);
  }

  static Component _paEvents(List<PaEventItem> events) {
    return section(classes: 'pa-section', [
      h2([.text('Upcoming PA Events and Meetings')]),
      if (events.isEmpty)
        p([
          .text('No upcoming events at this time. Check the '),
          Link(to: '/current-families#calendar', child: .text('school calendar')),
          .text(' for other key dates.'),
        ])
      else
        div(classes: 'card-grid', [for (final event in events) _paEventCard(event)]),
    ]);
  }

  static Component _paEventCard(PaEventItem event) {
    return CollectionCard(
      title: event.title,
      eyebrow: '${formatDate(event.eventDate)} · ${event.location}',
      excerpt: _excerpt(event.description),
    );
  }

  static String? _excerpt(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length <= 140) return trimmed;
    return '${trimmed.substring(0, 140).trimRight()}…';
  }

  static Component _duesLine(ParentAssociationInfo info) {
    return div(classes: 'pa-dues', [
      div(classes: 'pa-dues-item', [
        span(classes: 'pa-dues-label', [.text('Annual dues')]),
        span(classes: 'pa-dues-value', [.text(info.duesAnnual)]),
      ]),
      div(classes: 'pa-dues-item', [
        span(classes: 'pa-dues-label', [.text('Lifetime membership')]),
        span(classes: 'pa-dues-value', [.text(info.duesLifetime)]),
      ]),
    ]);
  }

  static Component _signupCta(ParentAssociationInfo info) {
    return div(classes: 'detail-cta', [
      a(
        href: info.signupUrl,
        target: Target.blank,
        classes: 'detail-cta-btn',
        [.text('Sign Up for PA Membership')],
      ),
    ]);
  }

  static Component _boardMembers(ParentAssociationInfo info) {
    return section(classes: 'pa-section', [
      h2([.text('PA Board Members')]),
      ul(classes: 'pa-board-list', [
        for (final member in info.boardMembers)
          li(classes: 'pa-board-item', [
            span(classes: 'pa-board-role', [.text('${member.role}: ')]),
            .text(member.name),
          ]),
      ]),
    ]);
  }

  static Component _contacts(ParentAssociationInfo info) {
    return section(classes: 'pa-section', [
      h2([.text('Contact')]),
      p([.text('For questions about the Parent Association, please reach out to:')]),
      ul(classes: 'pa-contact-list', [
        for (final contact in info.contacts)
          li(classes: 'pa-contact-item', [
            span(classes: 'pa-contact-name', [.text(contact.name)]),
            a(href: 'mailto:${contact.email}', classes: 'pa-contact-email', [.text(contact.email)]),
          ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.pa-dues').styles(
      display: .flex,
      margin: .only(top: 18.px),
      gap: .all(16.px),
    ),
    css('.pa-dues-item', [
      css('&').styles(
        padding: .all(14.px),
        border: .all(color: AppColors.borderLight, width: 2.px),
        radius: .all(.circular(10.px)),
        flex: Flex(grow: 1),
        backgroundColor: AppColors.shadedBg,
      ),
      css('.pa-dues-label').styles(
        display: .block,
        color: AppColors.muted,
        fontSize: 12.px,
      ),
      css('.pa-dues-value').styles(
        display: .block,
        margin: .only(top: 2.px),
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 20.px,
        fontWeight: .w700,
      ),
    ]),

    css('.pa-section').styles(margin: .only(top: 28.px)),
    css('.pa-section h2').styles(margin: .only(bottom: 10.px)),

    css('.pa-board-list').styles(
      padding: .zero,
      margin: .zero,
      listStyle: .none,
    ),
    css('.pa-board-item').styles(
      padding: .symmetric(vertical: 8.px, horizontal: 0.px),
      border: .only(bottom: .solid(color: AppColors.borderLight, width: 1.5.px)),
      color: AppColors.body,
      fontSize: 14.px,
    ),
    css('.pa-board-role').styles(
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontWeight: .w700,
    ),

    css('.pa-contact-list').styles(
      padding: .zero,
      margin: .only(top: 10.px),
      listStyle: .none,
    ),
    css('.pa-contact-item', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 8.px, horizontal: 0.px),
        border: .only(bottom: .solid(color: AppColors.borderLight, width: 1.5.px)),
        alignItems: .center,
        gap: .all(10.px),
      ),
      css('.pa-contact-name').styles(
        color: AppColors.ink,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 14.px,
        fontWeight: .w700,
      ),
      css('.pa-contact-email').styles(color: AppColors.primary, fontSize: 13.px),
    ]),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.pa-dues').styles(flexDirection: .column),
      css('.pa-contact-item').styles(flexDirection: .column, alignItems: .start, gap: .all(2.px)),
    ]),
  ];
}
