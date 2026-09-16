import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';
import 'icons.dart';

// The four-up shortcut strip that sits directly under the homepage hero.
// Icons come from the shared `icons.dart` set; see its own note on why these
// are real marks rather than the mockup's emoji.
// Hardcoded in Dart, not Sanity: this is a fixed set of shortcuts into the
// site's own structure, the same reasoning that keeps the nav a hardcoded
// array in `header.dart` and the services pill lists in code.
const _links = [
  (label: 'Programs', path: '/programs', icon: AppIcons.school),
  (label: 'Admissions', path: '/admissions', icon: AppIcons.assignment),
  (label: 'School Calendar', path: '/current-families#calendar', icon: AppIcons.calendar),
  (label: 'Support Us', path: '/support-us', icon: AppIcons.heart),
];

class QuickLinks extends StatelessComponent {
  const QuickLinks({super.key});

  @override
  Component build(BuildContext context) {
    return nav(
      classes: 'quick-links',
      attributes: const {'aria-label': 'Quick links'},
      [
        div(classes: 'quick-links-inner', [
          for (final link in _links)
            Link(
              to: link.path,
              classes: 'quick-link',
              child: .fragment([
                appIcon(link.icon, classes: 'quick-link-icon'),
                span([.text(link.label)]),
              ]),
            ),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.quick-links', [
      css('&').styles(
        // Same two tints as the bands above and below, run the other way, so
        // the strip reads as a divider between them rather than a third
        // colour. Both are existing tokens — see the Step 22 note on the
        // mockup's #fff8ed/#f9fcfd being within 2/255 of these.
        border: .only(bottom: BorderSide(width: 1.px, color: AppColors.line)),
        raw: {
          'background-image':
              'linear-gradient(90deg, ${AppColors.cream.value}, ${AppColors.offWhite.value})',
        },
      ),
      css('.quick-links-inner').styles(
        display: .grid,
        maxWidth: 1180.px,
        padding: .symmetric(horizontal: 24.px),
        margin: .symmetric(horizontal: .auto),
        gridTemplate: GridTemplate(
          columns: GridTracks(List.filled(4, GridTrack(TrackSize.fr(1)))),
        ),
      ),
      css('.quick-link', [
        css('&').styles(
          display: .flex,
          padding: .symmetric(vertical: 18.px, horizontal: 8.px),
          justifyContent: .center,
          alignItems: .center,
          gap: .all(10.px),
          color: AppColors.navy,
          textAlign: .center,
          fontSize: 0.95.rem,
          fontWeight: .w700,
          textDecoration: TextDecoration.none,
        ),
        // Dividers between items, not around them, so the row's outer edges
        // stay open the way the mockup has them.
        css('&:not(:last-child)').styles(
          border: .only(right: BorderSide(width: 1.px, color: AppColors.line)),
        ),
        css('&:hover').styles(color: AppColors.coral),
        css('.quick-link-icon').styles(
          width: 20.px,
          height: 20.px,
          color: AppColors.blue,
          raw: {'flex-shrink': '0'},
        ),
        css('&:hover .quick-link-icon').styles(color: AppColors.coral),
      ]),
      // Two-up rather than four at phone widths: four labels this long cannot
      // sit on one row without wrapping mid-word.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
        css('.quick-links-inner').styles(
          padding: .symmetric(horizontal: 20.px),
          gridTemplate: GridTemplate(
            columns: GridTracks(List.filled(2, GridTrack(TrackSize.fr(1)))),
          ),
        ),
        css('.quick-link', [
          css('&').styles(padding: .symmetric(vertical: 14.px, horizontal: 6.px), fontSize: 0.85.rem),
          // With two per row the last item is no longer the only one that
          // should lose its divider — every second one should.
          css('&:nth-child(2n)').styles(raw: {'border-right': 'none'}),
          css('&:nth-child(-n+2)').styles(
            border: .only(bottom: BorderSide(width: 1.px, color: AppColors.line)),
          ),
        ]),
      ]),
    ]),
  ];
}
