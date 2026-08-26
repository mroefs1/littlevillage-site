import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';

// Sitewide machine translation, ported from the legacy WordPress site's
// GTranslate plugin. That plugin ran with `url_structure: "none"`, which
// means it was a thin wrapper around Google's own Translate Element widget —
// so this component talks to that widget directly instead of reproducing a
// plugin around it.
//
// How it works: Google's widget reads a `googtrans` cookie on page load and
// translates the whole document if it's set. Every internal link on this
// site is a real page load (the router is server-rendered and never hydrated
// as a client-side router), so setting that cookie and reloading is enough
// to make the choice stick across the entire site — exactly the behaviour
// the WordPress site has today. There is no per-page state to keep in sync.
//
// This is the third documented exception to the project's "avoid
// hand-written JS" rule, approved 2026-08-26. Every line of it is Dart:
// the widget is loaded, configured and driven through `js_interop`, and no
// JS source strings appear anywhere in this file. All of the
// Google-specific machinery is deliberately confined to this one component,
// so replacing the translation engine later (the widget has been
// unmaintained since ~2018) is a one-file change rather than a site-wide
// one.

// The 13 languages the legacy site offered, in its order, labelled in each
// language's own name rather than in English — a Spanish speaker looking for
// their language scans for "Español", not "Spanish". Taken verbatim from the
// live WordPress widget's config rather than picked fresh: the list includes
// Haitian Creole and Urdu, which reads as a deliberate choice about this
// school's own families, not a default.
const _languages = <(String, String)>[
  ('en', 'English'),
  ('es', 'Español'),
  ('zh-CN', '简体中文'),
  ('zh-TW', '繁體中文'),
  ('ar', 'العربية'),
  ('hi', 'हिन्दी'),
  ('ur', 'اردو'),
  ('ht', 'Kreyol ayisyen'),
  ('fr', 'Français'),
  ('ko', '한국어'),
  ('de', 'Deutsch'),
  ('it', 'Italiano'),
  ('ru', 'Русский'),
];

const _sourceLanguage = 'en';
const _cookieName = 'googtrans';
const _mountId = 'google-translate-mount';
const _selectId = 'language-switcher-select';
const _widgetScriptSrc = 'https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';

// Google's widget calls this global once its script has loaded; assigning a
// Dart closure to it is what lets the whole integration stay in Dart.
@JS('googleTranslateElementInit')
external set _googleTranslateElementInit(JSFunction value);

@JS('google.translate.TranslateElement')
extension type _TranslateElement._(JSObject _) implements JSObject {
  external factory _TranslateElement(_TranslateElementOptions options, String containerId);
}

@JS()
@anonymous
extension type _TranslateElementOptions._(JSObject _) implements JSObject {
  external factory _TranslateElementOptions({String pageLanguage, bool autoDisplay});
}

@client
class LanguageSwitcher extends StatefulComponent {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();

  @css
  static List<StyleRule> get styles => [
    css('.language-switcher', [
      css('&').styles(
        display: .flex,
        position: .relative(),
        alignItems: .center,
        gap: .all(6.px),
      ),
      css('.language-switcher-icon').styles(fontSize: 0.875.rem),
      // `appearance: none` below strips the native dropdown arrow along with
      // the native chrome, so the control supplies its own. Decorative and
      // click-through — the select underneath still owns the interaction.
      css('.language-switcher-caret').styles(
        position: .absolute(right: 10.px, top: 50.percent),
        color: Colors.white,
        fontSize: 0.625.rem,
        raw: {'transform': 'translateY(-50%)', 'pointer-events': 'none'},
      ),
      css('.language-switcher-select', [
        css('&').styles(
          padding: .only(top: 4.px, bottom: 4.px, left: 10.px, right: 24.px),
          border: .all(color: AppColors.lineDark, width: 1.px),
          radius: .all(.circular(Radii.pill)),
          color: Colors.white,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 0.8125.rem,
          fontWeight: .w600,
          backgroundColor: Colors.transparent,
          // Without `appearance: none` browsers paint the select with native
          // OS chrome and silently ignore the color/background above — it
          // renders as a white box with black text against the navy bar.
          // Caught in a screenshot, not by the contrast math, which was
          // describing styling that wasn't actually taking effect.
          raw: {'cursor': 'pointer', 'appearance': 'none', '-webkit-appearance': 'none'},
        ),
        // The dropdown list itself is painted by the OS, which does not
        // inherit the white-on-navy treatment above — without this, the
        // open list renders white text on a white popup on Windows and
        // several Linux desktops.
        css('option').styles(
          color: AppColors.navy,
          backgroundColor: Colors.white,
        ),
        // White outline, not the sitewide blue: against the dark navy
        // utility bar blue clears only ~2:1, under the 3:1 WCAG floor for a
        // focus indicator. Same reasoning already documented for the
        // adjacent donate pill and the footer links.
        css('&:focus-visible').styles(
          outline: Outline(color: Colors.white, width: OutlineWidth(2.px), style: .solid),
          raw: {'outline-offset': '2px'},
        ),
      ]),
      // The select's intrinsic width is set by the longest option
      // ("Kreyol ayisyen"), which is 150px — enough to push the utility
      // bar's actions onto a second line on very narrow phones. Capping it
      // here lets the *selected* label ellipsize (it is almost always short:
      // "English", "Español", "한국어") while the full names stay intact in
      // the open list. Capping rather than dropping the globe icon, which is
      // the one affordance here that doesn't require reading English.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.small), [
        css('.language-switcher-select').styles(
          maxWidth: 110.px,
          raw: {'text-overflow': 'ellipsis'},
        ),
      ]),
      css('.language-switcher-label').styles(
        position: .absolute(),
        width: 1.px,
        height: 1.px,
        padding: .zero,
        margin: .all((-1).px),
        overflow: .hidden,
        raw: {'clip': 'rect(0, 0, 0, 0)', 'white-space': 'nowrap'},
      ),
    ]),
    // Google injects a hidden mount for its own (unstyled) control, plus a
    // banner iframe across the top of the page. The banner is deliberately
    // kept — it carries Google's attribution and the "Show original" escape
    // hatch — but its mount never needs to be seen.
    css('#$_mountId').styles(display: .none),
  ];
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  String _current = _sourceLanguage;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _current = _languageFromCookie();
      _loadWidget();
    }
  }

  // The cookie holds a `/<source>/<target>` pair, e.g. `/en/es`. Anything
  // else — absent, malformed, or naming a language this switcher no longer
  // offers — falls back to the untranslated source language, so a stale
  // cookie can never leave the control showing something it isn't set to.
  String _languageFromCookie() {
    final cookies = web.document.cookie.split(';');
    for (final cookie in cookies) {
      final parts = cookie.trim().split('=');
      if (parts.length < 2 || parts.first != _cookieName) continue;
      final segments = Uri.decodeComponent(parts.sublist(1).join('=')).split('/');
      if (segments.length < 3) continue;
      final target = segments[2];
      if (_languages.any((language) => language.$1 == target)) return target;
    }
    return _sourceLanguage;
  }

  void _loadWidget() {
    // Guard against a second mount (the switcher is rendered once today, but
    // a footer copy is an obvious future addition) re-injecting the script.
    if (web.document.getElementById(_mountId) != null) return;

    final mount = web.document.createElement('div') as web.HTMLDivElement;
    mount.id = _mountId;
    web.document.body?.append(mount);

    _googleTranslateElementInit = () {
      _TranslateElement(
        // `autoDisplay: false` stops the widget from translating on its own
        // guess at the visitor's language — it should only ever act on an
        // explicit choice, which is what the cookie records.
        _TranslateElementOptions(pageLanguage: _sourceLanguage, autoDisplay: false),
        _mountId,
      );
    }.toJS;

    final script = web.document.createElement('script') as web.HTMLScriptElement;
    script.src = _widgetScriptSrc;
    script.async = true;
    web.document.head?.append(script);
  }

  // Google reads the cookie on load, so a reload is what actually applies
  // the change — and since every internal link is a full page load anyway,
  // the choice then persists for the rest of the visit with no further work.
  void _select(String language) {
    if (!kIsWeb || language == _current) return;
    final host = web.window.location.hostname;
    if (language == _sourceLanguage) {
      // Returning to English clears the cookie rather than setting `/en/en`:
      // an absent cookie is the one state the widget treats as "do nothing",
      // so the page comes back genuinely untranslated.
      web.document.cookie = '$_cookieName=; path=/; max-age=0';
      web.document.cookie = '$_cookieName=; path=/; domain=$host; max-age=0';
    } else {
      const oneYearInSeconds = 31536000;
      final value = '/$_sourceLanguage/$language';
      web.document.cookie = '$_cookieName=$value; path=/; max-age=$oneYearInSeconds; samesite=lax';
    }
    web.window.location.reload();
  }

  @override
  Component build(BuildContext context) {
    // `translate="no"` keeps the widget from translating its own control:
    // without it, choosing Spanish rewrites every option label into Spanish,
    // so a visitor who wanted Korean can no longer find "한국어" in the list.
    return div(
      classes: 'language-switcher notranslate',
      attributes: const {'translate': 'no'},
      [
        span(classes: 'language-switcher-icon', attributes: const {'aria-hidden': 'true'}, [.text('🌐')]),
        span(classes: 'language-switcher-caret', attributes: const {'aria-hidden': 'true'}, [.text('▾')]),
        label(classes: 'language-switcher-label', attributes: const {'for': _selectId}, [.text('Language')]),
        select(
          id: _selectId,
          classes: 'language-switcher-select',
          onChange: (values) {
            if (values.isNotEmpty) _select(values.first);
          },
          [
            for (final (code, name) in _languages)
              option(value: code, selected: code == _current, [.text(name)]),
          ],
        ),
      ],
    );
  }
}
