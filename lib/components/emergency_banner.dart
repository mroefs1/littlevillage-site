import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'icons.dart';

// The red bar across the top of every page while an emergency notification -
// a snow day, a closure - is live in Sanity.
//
// It is baked into the static HTML at build time, so it appears one rebuild
// after publishing (the Sanity webhook triggers that) and needs no script to
// show. What a static build cannot do is take it down again: nothing rebuilds
// at the moment a notice expires, and a "closed today" bar still up the next
// morning is worse than no bar. So this is a `@client` island whose only job
// in the browser is to check the clock - it removes itself on load when the
// notice has already expired, and on a timer when it expires while the page
// is open.
//
// The one cost is a brief flash: a visitor who arrives after expiry but
// before the next rebuild sees the stale bar until the client bundle loads.
// A blocking inline script would avoid that, but would be a fifth sanctioned
// piece of hand-written JS (see CLAUDE.md), and the window is narrow - the
// next publish of anything clears it from the HTML for good.

// The browser clamps any `setTimeout` past 2^31-1 ms (~24.8 days) to fire
// immediately, which would hide a long-running notice the moment it loaded.
// Past this, no timer: the load-time check covers it.
const _maxTimerDelay = Duration(days: 24);

@client
class EmergencyBanner extends StatefulComponent {
  const EmergencyBanner({
    required this.title,
    required this.text,
    required this.expiresMs,
    this.moreInfoLink,
    super.key,
  });

  // Plain values only: `@client` parameters have to be serializable, the
  // same constraint documented on `FaqAccordion` and `SplashScreen`.
  final String title;
  final String text;
  final int expiresMs;
  final String? moreInfoLink;

  @override
  State<EmergencyBanner> createState() => _EmergencyBannerState();

  @css
  static List<StyleRule> get styles => [
    css('.emergency-bar', [
      css('&').styles(
        padding: .symmetric(vertical: 12.px, horizontal: 40.px),
        color: Colors.white,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        backgroundColor: AppColors.danger,
      ),
      css('.emergency-inner').styles(
        display: .flex,
        alignItems: .start,
        gap: .all(12.px),
      ),
      // An SVG has no intrinsic size, and the text beside it can wrap to
      // several lines on a phone - so explicit dimensions and no shrinking.
      css('.emergency-icon').styles(
        width: 24.px,
        height: 24.px,
        flex: Flex(grow: 0, shrink: 0),
      ),
      css('.emergency-body').styles(minWidth: Unit.zero, fontSize: 0.9375.rem, raw: {'line-height': '1.45'}),
      css('.emergency-title').styles(fontWeight: .w700),
      css('.emergency-text').styles(margin: .zero),
      css('.emergency-link').styles(
        color: Colors.white,
        fontWeight: .w700,
        textDecoration: const TextDecoration(line: TextDecorationLine.underline),
      ),
      // The site's default focus ring does not clear 3:1 against this red.
      css('.emergency-link:focus-visible').styles(
        outline: Outline(color: Colors.white, width: OutlineWidth(2.px), style: .solid),
        raw: {'outline-offset': '2px'},
      ),
    ]),
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.emergency-bar').styles(padding: .symmetric(vertical: 10.px, horizontal: 20.px)),
    ]),
  ];
}

class _EmergencyBannerState extends State<EmergencyBanner> {
  bool _expired = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Server-side the build has already filtered out expired notices, and the
    // build's clock is the wrong one to ask anyway. Only the browser's counts.
    if (!kIsWeb) return;
    final remaining = Duration(milliseconds: component.expiresMs - DateTime.now().millisecondsSinceEpoch);
    if (remaining <= Duration.zero) {
      _expired = true;
    } else if (remaining < _maxTimerDelay) {
      _timer = Timer(remaining, () => setState(() => _expired = true));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    if (_expired) return const .fragment([]);

    final link = component.moreInfoLink;
    final paragraphs = component.text.split('\n').where((para) => para.trim().isNotEmpty).toList();

    // A labelled region rather than `role="alert"`: this is on the page from
    // the first byte, not a change announced mid-visit, and an alert role on
    // every page load of a multi-day closure would interrupt a screen reader
    // user on every single navigation. Being first in the DOM is what makes
    // it the first thing read.
    return section(
      classes: 'emergency-bar',
      attributes: const {'aria-label': 'Emergency notice'},
      [
        div(classes: 'emergency-inner', [
          appIcon(AppIcons.warning, classes: 'emergency-icon'),
          div(classes: 'emergency-body', [
            if (component.title.isNotEmpty) div(classes: 'emergency-title', [.text(component.title)]),
            for (final para in paragraphs) p(classes: 'emergency-text', [.text(para)]),
            if (link != null && link.isNotEmpty)
              p(classes: 'emergency-text', [
                // Same convention as the footer and nav: off-site opens a new
                // tab, a path on this site navigates normally.
                if (link.startsWith('http'))
                  a(href: link, target: Target.blank, classes: 'emergency-link', [.text('More information →')])
                else
                  a(href: link, classes: 'emergency-link', [.text('More information →')]),
              ]),
          ]),
        ]),
      ],
    );
  }
}
