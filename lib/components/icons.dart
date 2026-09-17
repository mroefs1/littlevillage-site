import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

// Shared UI icons, as inlined 24x24 single-path marks from Material Symbols
// (Apache 2.0). Same reasoning as `social_icons.dart`: they inherit
// `currentColor`, cost no extra request, and render identically on every
// platform — unlike the emoji the Step 30 mockup uses for these slots, which
// are a font and look different on every OS.
//
// Every one of these is decorative. The surrounding link or heading carries
// the meaning, so [appIcon] marks them `aria-hidden` and there is no variant
// that does otherwise.
class AppIcons {
  static const school =
      'M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z';
  static const assignment =
      'M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 '
      '0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm'
      '3-4H7v-2h10v2zm0-4H7V7h10v2z';
  static const calendar =
      'M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19a2 2 0 0 0 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2'
      '-2-2zm0 16H5V8h14v11z';
  static const heart =
      'M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 '
      '3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z';
  static const document =
      'M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H'
      '8v-2h8v2zm-3-5V3.5L18.5 9H13z';
  static const groups =
      'M12 12.75c1.63 0 3.07.39 4.24.9 1.08.48 1.76 1.56 1.76 2.73V18H6v-1.61c0-1.18.68-2.26 1.76-2.73 1.'
      '17-.52 2.61-.91 4.24-.91zM4 13c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm1.13 1.1c-.37-.06-.74-.'
      '1-1.13-.1-.99 0-1.93.21-2.78.58C.48 14.9 0 15.62 0 16.43V18h4.5v-1.61c0-.83.23-1.61.63-2.29zM20 13'
      'c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm4 3.43c0-.81-.48-1.53-1.22-1.85-.85-.37-1.79-.58-2.78'
      '-.58-.39 0-.76.04-1.13.1.4.68.63 1.46.63 2.29V18H24v-1.57zM12 6c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.'
      '34-3-3 1.34-3 3-3z';
}

/// A decorative icon, painted in the surrounding text colour and sized by the
/// [classes] the caller passes.
Component appIcon(String iconPath, {String? classes}) {
  return svg(
    viewBox: '0 0 24 24',
    classes: classes,
    attributes: const {'fill': 'currentColor', 'aria-hidden': 'true', 'focusable': 'false'},
    [path(d: iconPath, [])],
  );
}
