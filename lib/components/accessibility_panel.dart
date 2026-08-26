import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';

// Visitor-controlled display preferences: text size, reduced motion, and
// always-underlined links. Deliberately a small set of controls that each do
// something real, rather than a third-party accessibility overlay.
//
// That is a considered choice, not an oversight. Overlays are widely held
// not to deliver conformance - the FTC fined accessiBe $1M in April 2025
// over compliance claims, 22.6% of US web accessibility lawsuits in H1 2025
// targeted sites that already had one installed, and screen readers read the
// DOM rather than an overlay's script. For a school whose credibility rests
// on serving disabled children, a widget that performs accessibility without
// delivering it is worse than nothing. The real work is in the markup: this
// panel only exposes the handful of preferences a visitor genuinely cannot
// set for themselves elsewhere.
//
// Notably absent, and intentionally: "screen reader mode", dyslexia-friendly
// fonts (the evidence for those typefaces is weak), cursor sizing and
// "epilepsy safe mode". Those are the overlay features that create a false
// impression of accessibility.
//
// Preferences are stored per-browser in localStorage and applied as
// attributes on <html>, so the CSS below can key off them. The site's own
// typography is in rem, so a visitor who has already set a larger default
// font size in their browser or OS gets that for free without ever opening
// this panel - this is for people who have not.

const _storageKey = 'lv-a11y-prefs';
const _panelId = 'accessibility-panel';

// Attribute names shared with the boot script below. `data-text-size` is
// only ever *present* when the size is non-default: the nav collapse rules
// in `mobile_nav.dart` key off its presence alone.
const _textSizeAttr = 'data-text-size';
const _reduceMotionAttr = 'data-reduce-motion';
const _underlineLinksAttr = 'data-underline-links';

const _sizes = <(String, String)>[
  ('default', 'Default'),
  ('large', 'Large'),
  ('larger', 'Largest'),
];

// Applied before first paint, from the document head. This has to be a
// blocking inline script: the Dart client bundle loads after the first paint,
// so applying the preferences there would show every page at the default size
// and then visibly jump - worst for exactly the people who set a larger size.
// It is deliberately tiny, dependency-free, and reads the same key and
// attributes the Dart component writes.
class AccessibilityBoot extends StatelessComponent {
  const AccessibilityBoot({super.key});

  @override
  Component build(BuildContext context) {
    return Document.head(
      children: [
        const script(
          content:
              "try{var p=JSON.parse(localStorage.getItem('$_storageKey')||'{}'),d=document.documentElement;"
              "if(p.textSize&&p.textSize!=='default')d.setAttribute('$_textSizeAttr',p.textSize);"
              "if(p.reduceMotion)d.setAttribute('$_reduceMotionAttr','true');"
              "if(p.underlineLinks)d.setAttribute('$_underlineLinksAttr','true');}catch(e){}",
        ),
      ],
    );
  }
}

@client
class AccessibilityPanel extends StatefulComponent {
  const AccessibilityPanel({super.key});

  @override
  State<AccessibilityPanel> createState() => _AccessibilityPanelState();

  @css
  static List<StyleRule> get styles => [
    // --- What the preferences actually do (global, keyed off <html>) ---

    // Percentages, not px: they multiply the visitor's own default size
    // rather than replacing it, so someone who has already enlarged text in
    // their browser and then picks "Large" here gets both, not the lesser.
    css('html[$_textSizeAttr="large"]').styles(fontSize: 112.5.percent),
    css('html[$_textSizeAttr="larger"]').styles(fontSize: 125.percent),

    // The `!important` here is deliberate and is the conventional form of
    // this reset: it has to beat animation/transition declarations wherever
    // they are defined, and a visitor asking for less motion should not be
    // overridden by a component's own styling.
    css('html[$_reduceMotionAttr="true"] *').styles(
      raw: {
        'animation-duration': '0.01ms !important',
        'animation-iteration-count': '1 !important',
        'transition-duration': '0.01ms !important',
        'scroll-behavior': 'auto !important',
      },
    ),

    // Excludes anything already shaped like a button or a whole-card link -
    // underlining those reads as a rendering fault rather than a link.
    css(
      'html[$_underlineLinksAttr="true"] a:not([class*="btn"]):not([class*="pill"])'
      ':not(.link-card):not(.request-info):not(.brand):not(.skip-link)',
    ).styles(textDecoration: const TextDecoration(line: TextDecorationLine.underline)),

    // Three controls plus the donate pill do not fit a phone's utility bar:
    // at 320px they needed 340px of a 280px row, and because the bar is
    // right-justified the overflow ran off the *left* edge, clipping the
    // language switcher without registering as document overflow at all.
    // Dropping the button's visible word (the icon and its accessible name
    // both remain) buys back the ~50px that makes it fit.
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.a11y-toggle-text').styles(display: .none),
      css('.a11y-panel').styles(width: 230.px),
    ]),

    // --- The control itself ---
    css('.a11y', [
      css('&').styles(display: .flex, position: .relative()),
      css('.a11y-toggle', [
        css('&').styles(
          display: .flex,
          padding: .symmetric(vertical: 4.px, horizontal: 10.px),
          border: .all(color: AppColors.lineDark, width: 1.px),
          radius: .all(.circular(Radii.pill)),
          alignItems: .center,
          gap: .all(6.px),
          color: Colors.white,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.8125.rem,
          fontWeight: .w600,
          whiteSpace: .noWrap,
          backgroundColor: Colors.transparent,
          raw: {'cursor': 'pointer'},
        ),
        // White, not the sitewide blue: against the navy utility bar blue
        // clears only ~2:1, under the 3:1 floor for a focus indicator. Same
        // reasoning as the adjacent donate pill and language switcher.
        css('&:focus-visible').styles(
          outline: Outline(color: Colors.white, width: OutlineWidth(2.px), style: .solid),
          raw: {'outline-offset': '2px'},
        ),
      ]),
      css('.a11y-panel', [
        css('&').styles(
          display: .flex,
          position: .absolute(top: 100.percent, right: 0.px),
          width: 250.px,
          padding: .all(16.px),
          margin: .only(top: 8.px),
          border: .all(color: AppColors.line, width: 1.px),
          radius: .all(.circular(Radii.lg)),
          shadow: BoxShadow(offsetX: 0.px, offsetY: 8.px, blur: 24.px, color: .rgba(23, 51, 74, 0.18)),
          flexDirection: .column,
          gap: .all(14.px),
          color: AppColors.navy,
          textAlign: .left,
          backgroundColor: Colors.white,
          raw: {'z-index': '40'},
        ),
        css('.a11y-group-label').styles(
          margin: .only(bottom: 6.px),
          color: AppColors.mutedText,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.75.rem,
          fontWeight: .w700,
          textTransform: .upperCase,
          letterSpacing: 0.08.em,
        ),
        css('.a11y-sizes').styles(display: .flex, gap: .all(6.px)),
        css('.a11y-size', [
          css('&').styles(
            padding: .symmetric(vertical: 6.px, horizontal: 10.px),
            border: .all(color: AppColors.line, width: 1.px),
            radius: .all(.circular(Radii.pill)),
            flex: Flex(grow: 1),
            color: AppColors.navy,
            fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
            fontSize: 0.8125.rem,
            fontWeight: .w600,
            backgroundColor: Colors.white,
            raw: {'cursor': 'pointer'},
          ),
          css('&[aria-pressed="true"]').styles(
            border: .all(color: AppColors.coral, width: 1.px),
            color: Colors.white,
            backgroundColor: AppColors.coral,
          ),
        ]),
        // A real checkbox, so it is announced and operated exactly as a
        // visitor's assistive technology already expects.
        css('.a11y-check', [
          css('&').styles(
            display: .flex,
            alignItems: .center,
            gap: .all(8.px),
            fontSize: 0.875.rem,
            raw: {'cursor': 'pointer'},
          ),
          css('input').styles(
            width: 16.px,
            height: 16.px,
            raw: {'cursor': 'pointer', 'accent-color': AppColors.coral.value},
          ),
        ]),
        css('.a11y-note').styles(
          color: AppColors.mutedTextLight,
          fontSize: 0.75.rem,
          lineHeight: 1.45.em,
        ),
      ]),
    ]),
  ];
}

class _AccessibilityPanelState extends State<AccessibilityPanel> {
  bool _open = false;
  String _textSize = 'default';
  bool _reduceMotion = false;
  bool _underlineLinks = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _load();
  }

  void _load() {
    try {
      final stored = web.window.localStorage.getItem(_storageKey);
      if (stored == null) return;
      final decoded = jsonDecode(stored);
      if (decoded is! Map) return;
      final size = decoded['textSize'];
      _textSize = _sizes.any((entry) => entry.$1 == size) ? size as String : 'default';
      _reduceMotion = decoded['reduceMotion'] == true;
      _underlineLinks = decoded['underlineLinks'] == true;
    } catch (_) {
      // A malformed or unreadable value (private browsing, cleared storage,
      // a hand-edited key) just means defaults - never a broken page.
    }
  }

  void _persistAndApply() {
    if (!kIsWeb) return;
    final root = web.document.documentElement;
    if (root == null) return;

    if (_textSize == 'default') {
      root.removeAttribute(_textSizeAttr);
    } else {
      root.setAttribute(_textSizeAttr, _textSize);
    }
    _toggleAttribute(root, _reduceMotionAttr, _reduceMotion);
    _toggleAttribute(root, _underlineLinksAttr, _underlineLinks);

    try {
      web.window.localStorage.setItem(
        _storageKey,
        jsonEncode({'textSize': _textSize, 'reduceMotion': _reduceMotion, 'underlineLinks': _underlineLinks}),
      );
    } catch (_) {
      // Storage can throw outright in private browsing. The preference still
      // applies for this page view; it just will not be remembered.
    }
  }

  void _toggleAttribute(web.Element root, String name, bool on) {
    if (on) {
      root.setAttribute(name, 'true');
    } else {
      root.removeAttribute(name);
    }
  }

  void _setSize(String size) {
    setState(() => _textSize = size);
    _persistAndApply();
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'a11y', [
      button(
        classes: 'a11y-toggle',
        type: .button,
        onClick: () => setState(() => _open = !_open),
        attributes: {
          'aria-expanded': _open ? 'true' : 'false',
          'aria-controls': _panelId,
          // Named explicitly, because the visible word is dropped at phone
          // widths where the bar has no room for it. The accessible name
          // still contains the visible label, per WCAG 2.5.3 Label in Name.
          'aria-label': 'Display settings',
        },
        [
          span(attributes: const {'aria-hidden': 'true'}, [.text('◐')]),
          span(classes: 'a11y-toggle-text', [.text('Display')]),
        ],
      ),
      if (_open)
        div(id: _panelId, classes: 'a11y-panel', [
          div([
            div(classes: 'a11y-group-label', id: 'a11y-size-label', [.text('Text size')]),
            div(
              classes: 'a11y-sizes',
              attributes: const {'role': 'group', 'aria-labelledby': 'a11y-size-label'},
              [
                for (final (value, label) in _sizes)
                  button(
                    classes: 'a11y-size',
                    type: .button,
                    onClick: () => _setSize(value),
                    attributes: {'aria-pressed': _textSize == value ? 'true' : 'false'},
                    [.text(label)],
                  ),
              ],
            ),
          ]),
          label(classes: 'a11y-check', [
            input(
              type: InputType.checkbox,
              attributes: {if (_reduceMotion) 'checked': 'checked'},
              onChange: (_) {
                setState(() => _reduceMotion = !_reduceMotion);
                _persistAndApply();
              },
            ),
            span([.text('Reduce motion')]),
          ]),
          label(classes: 'a11y-check', [
            input(
              type: InputType.checkbox,
              attributes: {if (_underlineLinks) 'checked': 'checked'},
              onChange: (_) {
                setState(() => _underlineLinks = !_underlineLinks);
                _persistAndApply();
              },
            ),
            span([.text('Underline all links')]),
          ]),
          div(classes: 'a11y-note', [
            .text('Saved in this browser. Your device\'s own text size and motion settings are respected too.'),
          ]),
        ]),
    ]);
  }
}
