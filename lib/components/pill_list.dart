import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// One pill. [href] is optional: a pill with a link target renders as an
/// anchor, one without renders as an inert `<span>` (same deliberate choice as
/// the brick-campaign CTA on Support Us — a few services, like Transportation
/// or Family Training, genuinely have no Therapeutic Services section to point
/// at, and a link to the wrong place is worse than no link).
class Pill {
  final String label;
  final String? href;

  const Pill(this.label, {this.href});
}

// Rounded pill row for short tag-like lists — therapies offered, services
// included. Used on the programs hub and program detail pages.
class PillList extends StatelessComponent {
  final List<Pill> items;

  const PillList(this.items, {super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'pill-list', [
      for (final item in items)
        if (item.href case final href?)
          a(href: href, classes: 'pill pill-link', [
            .text(item.label),
            // Non-color cue that this pill goes somewhere, so linked and
            // inert pills aren't told apart by color alone (WCAG 1.4.1).
            // Decorative — the visible label is already the link text, and
            // reading "right arrow" after every service adds nothing.
            span(classes: 'pill-arrow', attributes: {'aria-hidden': 'true'}, [.text('→')]),
          ])
        else
          span(classes: 'pill', [.text(item.label)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.pill-list').styles(display: .flex, flexWrap: .wrap, gap: .all(12.px)),
    css('.pill').styles(
      padding: .symmetric(vertical: 8.px, horizontal: 16.px),
      border: .all(color: AppColors.line, width: 1.px),
      radius: .all(.circular(Radii.pill)),
      color: AppColors.navy,
      fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
      fontSize: 0.875.rem,
      fontWeight: .w600,
      backgroundColor: Colors.white,
    ),
    // Coral matches every other link/CTA on the site and was contrast-verified
    // in Step 11.10. Note the display-preferences panel's "underline all
    // links" rule deliberately skips `[class*="pill"]`: these read as
    // button-like CTAs, same as the donate pill, and carry the arrow instead.
    css('.pill-link').styles(color: AppColors.coral),
    css('.pill-link:hover').styles(
      border: .all(color: AppColors.coral, width: 1.px),
      backgroundColor: AppColors.peach,
    ),
    css('.pill-arrow').styles(margin: .only(left: 6.px)),
  ];
}
