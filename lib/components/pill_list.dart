import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

// Rounded pill row for short tag-like lists — therapies offered, services
// included. Used on the programs hub and program detail pages.
class PillList extends StatelessComponent {
  final List<String> items;

  const PillList(this.items, {super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'pill-list', [for (final item in items) span(classes: 'pill', [.text(item)])]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.pill-list').styles(display: .flex, flexWrap: .wrap, gap: .all(12.px)),
    css('.pill').styles(
      padding: .symmetric(vertical: 8.px, horizontal: 16.px),
      border: .all(color: AppColors.borderMedium, width: 1.5.px),
      radius: .all(.circular(20.px)),
      color: AppColors.ink,
      fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
      fontSize: 14.px,
      backgroundColor: Colors.white,
    ),
  ];
}
