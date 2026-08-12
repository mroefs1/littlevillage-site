import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

// A stand-in for real photography, per the design handoff: a hatched,
// dashed-border box with a short label. Swap for `img(src: ...)` once real
// photos are available for a given spot.
class PhotoPlaceholder extends StatelessComponent {
  final String label;
  final Unit? height;

  const PhotoPlaceholder(this.label, {this.height, super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'photo-placeholder',
      styles: height != null ? Styles(height: height) : null,
      [.text(label)],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.photo-placeholder').styles(
      display: .flex,
      height: 140.px,
      padding: .all(12.px),
      border: .all(color: AppColors.peachDark, width: 2.px, style: .dashed),
      radius: .all(.circular(Radii.sm)),
      justifyContent: .center,
      alignItems: .center,
      color: AppColors.mutedTextMid,
      textAlign: .center,
      fontFamily: FontFamilies.uiMonospace,
      fontSize: 12.px,
      fontWeight: .w600,
      raw: {
        'background-image':
            'repeating-linear-gradient(45deg, ${AppColors.peach.value}, ${AppColors.peach.value} 9px, ${AppColors.peachDark.value} 9px, ${AppColors.peachDark.value} 18px)',
      },
    ),
  ];
}
