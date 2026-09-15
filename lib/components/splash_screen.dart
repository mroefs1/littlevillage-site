import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';
import '../sanity/image_url.dart';

// The first-visit splash screen: a modal promoting one upcoming event, shown
// once per visitor on whichever page they arrive at, then dismissed for good.
//
// Visibility is driven entirely by a `data-splash` attribute on <html>, set by
// the boot script below before first paint. The Dart island never decides
// whether to appear - it only renders the markup and takes the attribute away
// when the visitor closes it. That split is what keeps this flicker-free on a
// static site (see `SplashBoot`).
//
// The event's own graphic carries every detail as pixels - recipient, date,
// venue, and a QR code for tickets - which a screen reader, a translation
// widget and a phone-sized viewport all get nothing from. So the image is
// accompanied by the same details as real text and a real ticket link, and
// carries editor-written alt text from Sanity.

const _storageKey = 'lv-splash-seen';

// Present only while the splash should be shown. Both the overlay's own
// visibility and the background scroll lock key off it, so closing is one
// attribute removal rather than several coordinated style changes.
const _splashAttr = 'data-splash';

const _titleId = 'splash-title';

/// Decides before first paint whether the splash should be shown, and says so
/// by setting `data-splash="on"` on `<html>`.
///
/// This has to be a blocking inline script, for the same reason
/// `AccessibilityBoot` does: the Dart client bundle loads *after* the first
/// paint. An island that decided this at hydration would either flash the
/// splash at everyone who already dismissed it, or pop it in late for everyone
/// who hasn't. Neither is acceptable on a page a visitor sees exactly once.
///
/// The logic is deliberately inverted relative to `AccessibilityBoot`: the
/// splash is hidden by default and this turns it *on*. So a visitor with no
/// JavaScript - or a crawler that doesn't run it - gets an ordinary, fully
/// usable page rather than a modal nothing can close.
///
/// It also re-checks the promo's date window on every page load. That is the
/// half of expiry a static site cannot do on its own: the build-time check in
/// `SplashPromo.shouldRender` only takes effect at the next rebuild, which
/// might be weeks after the event.
class SplashBoot extends StatelessComponent {
  const SplashBoot({
    required this.promoKey,
    required this.startMs,
    required this.endMs,
    this.eventPath,
    super.key,
  });

  /// Identifies this promo in storage. Changing which event is promoted
  /// changes this, so a new promo shows again for everyone with no key
  /// bookkeeping in Sanity.
  final String promoKey;
  final int startMs;
  final int endMs;

  /// The promoted event's own page. No point interrupting someone to
  /// advertise the page they are already reading.
  final String? eventPath;

  @override
  Component build(BuildContext context) {
    // Written without regex or template literals so nothing here collides with
    // Dart's own string interpolation.
    final js =
        "(function(){try{"
        "var n=Date.now();if(n<$startMs||n>$endMs)return;"
        "${eventPath == null ? '' : "var p=location.pathname;"
              "if(p.length>1&&p.charAt(p.length-1)==='/')p=p.slice(0,-1);"
              "if(p==='$eventPath')return;"}"
        // Its own try/catch: storage throws outright in some private-browsing
        // modes, and that should not cost the visitor the splash.
        "try{if(localStorage.getItem('$_storageKey')==='$promoKey')return;}catch(e){}"
        "document.documentElement.setAttribute('$_splashAttr','on');"
        "}catch(e){}})();";

    return Document.head(children: [script(content: js)]);
  }
}

@client
class SplashScreen extends StatefulComponent {
  const SplashScreen({
    required this.imageUrl,
    required this.imageAlt,
    required this.headline,
    required this.dateLine,
    required this.promoKey,
    this.eventLocation,
    this.ctaLabel,
    this.ctaHref,
    this.detailHref,
    super.key,
  });

  // All plain strings: `@client` parameters have to be serializable, the same
  // constraint documented on `FaqAccordion` and `NewsEventsFilter`.
  final String imageUrl;
  final String imageAlt;
  final String headline;
  final String dateLine;
  final String promoKey;
  final String? eventLocation;
  final String? ctaLabel;
  final String? ctaHref;
  final String? detailHref;

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  @css
  static List<StyleRule> get styles => [
    // Hidden unless the boot script says otherwise. Written as two separate
    // top-level rules rather than one nested block: `css()` inside a nested
    // block only prefixes the first selector of a comma-separated list, which
    // has silently swallowed rules here twice before.
    css('.splash-overlay').styles(display: .none),
    css('html[$_splashAttr="on"] .splash-overlay').styles(display: .flex),

    // The scroll lock rides on the same attribute, so it is correct before
    // hydration too and lifts the moment the attribute is removed.
    css('html[$_splashAttr="on"] body').styles(overflow: .hidden),

    // Deliberately sets no `display` of its own. The two rules above own that
    // property between them, and a `display: flex` here would be a same-
    // specificity rule emitted *later* than the `display: none` default -
    // silently winning, and showing the splash to everyone on every page
    // regardless of the attribute. Caught by reading the built CSS.
    css('.splash-overlay', [
      css('&').styles(
        position: .fixed(top: 0.px, right: 0.px, bottom: 0.px, left: 0.px),
        padding: .all(20.px),
        justifyContent: .center,
        alignItems: .center,
        backgroundColor: const Color.rgba(23, 51, 74, 0.72),
        raw: {'z-index': '200'},
      ),
    ]),

    css('.splash-card', [
      css('&').styles(
        display: .flex,
        position: .relative(),
        width: 100.percent,
        maxWidth: 620.px,
        maxHeight: 90.vh,
        radius: .all(.circular(Radii.xxl)),
        overflow: .hidden,
        shadow: BoxShadow(
          offsetX: 0.px,
          offsetY: 18.px,
          blur: 48.px,
          color: const Color.rgba(16, 47, 67, 0.45),
        ),
        flexDirection: .column,
        backgroundColor: Colors.white,
      ),
      // Focused on open so the dialog's own heading is read first rather than
      // the close button - but it is a container, not a control, so it does
      // not draw a focus ring of its own.
      css('&:focus').styles(raw: {'outline': 'none'}),
    ]),

    // Outside the scrolling region, so it stays reachable however tall the
    // artwork is.
    css('.splash-close', [
      css('&').styles(
        display: .flex,
        position: .absolute(top: 12.px, right: 12.px),
        width: 44.px,
        height: 44.px,
        padding: .zero,
        border: .all(color: AppColors.line, width: 1.px),
        radius: .all(.circular(Radii.pill)),
        justifyContent: .center,
        alignItems: .center,
        color: AppColors.navy,
        fontSize: 1.5.rem,
        lineHeight: 1.em,
        backgroundColor: Colors.white,
        // A 44px target on artwork that is usually dark: WCAG 2.5.8 asks for
        // 24px, and a white disc is what keeps it legible over the flyer.
        raw: {'cursor': 'pointer', 'z-index': '1'},
      ),
      css('&:hover').styles(backgroundColor: AppColors.peach),
      css('&:focus-visible').styles(
        outline: Outline(color: AppColors.blue, width: OutlineWidth(2.px), style: .solid),
        raw: {'outline-offset': '2px'},
      ),
    ]),

    css('.splash-scroll').styles(overflow: .auto),

    // `contain`, never `cover`: a cropped QR code is an unscannable QR code,
    // and these graphics are laid out edge to edge.
    css('.splash-image').styles(
      display: .block,
      width: 100.percent,
      maxHeight: 58.vh,
      backgroundColor: AppColors.offWhite,
      raw: {'object-fit': 'contain'},
    ),

    css('.splash-body', [
      css('&').styles(
        display: .flex,
        padding: .all(24.px),
        flexDirection: .column,
        gap: .all(10.px),
      ),
      css('.splash-title').styles(
        margin: .zero,
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.5.rem,
        fontWeight: .w600,
        letterSpacing: (-0.015).em,
        lineHeight: 1.2.em,
      ),
      css('.splash-meta').styles(
        margin: .zero,
        color: AppColors.mutedText,
        fontSize: 0.9375.rem,
        lineHeight: 1.5.em,
      ),
      css('.splash-actions').styles(
        display: .flex,
        margin: .only(top: 6.px),
        flexWrap: .wrap,
        alignItems: .center,
        gap: .all(16.px),
      ),
      css('.splash-cta', [
        css('&').styles(
          display: .inlineBlock,
          padding: .symmetric(vertical: 12.px, horizontal: 24.px),
          radius: .all(.circular(Radii.pill)),
          color: Colors.white,
          fontWeight: .w600,
          backgroundColor: AppColors.coral,
        ),
        css('&:hover').styles(backgroundColor: AppColors.navy),
      ]),
      css('.splash-detail', [
        css('&').styles(color: AppColors.coral, fontWeight: .w600),
        css('&:hover').styles(textDecoration: const TextDecoration(line: TextDecorationLine.underline)),
      ]),
    ]),

    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile), [
      css('.splash-overlay').styles(padding: .all(12.px)),
      css('.splash-card').styles(maxHeight: 94.vh),
      css('.splash-image').styles(maxHeight: 44.vh),
      css('.splash-body').styles(padding: .all(18.px)),
      css('.splash-title').styles(fontSize: 1.25.rem),
    ]),
  ];
}

class _SplashScreenState extends State<SplashScreen> {
  bool _dismissed = false;

  final _cardKey = GlobalNodeKey<web.HTMLDivElement>();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    // The server-rendered dialog carries `autofocus`, which covers the window
    // before the client bundle loads - but hydration re-creates the node, and
    // `autofocus` only ever fires once, at parse time. Measured: without this,
    // focus sat on <body> and the first Tab walked straight out of the dialog
    // into the page behind it. Guarded on the attribute, or a visitor who
    // already dismissed the splash would have focus pulled into a hidden
    // element on every page load.
    if (web.document.documentElement?.getAttribute(_splashAttr) != 'on') return;
    Timer.run(() => _cardKey.currentNode?.focus());
  }

  void _close() {
    if (kIsWeb) {
      try {
        web.window.localStorage.setItem(_storageKey, component.promoKey);
      } catch (_) {
        // Private browsing can throw. The splash still closes for this page
        // view; it just will not be remembered.
      }
      web.document.documentElement?.removeAttribute(_splashAttr);
      // Back to the top of the page content, which already carries
      // `tabindex="-1"` for the skip link. Returning focus to the body would
      // restart a keyboard visitor at the browser chrome.
      (web.document.getElementById('main-content') as web.HTMLElement?)?.focus();
    }
    setState(() => _dismissed = true);
  }

  /// A click on the dimmed area around the card, rather than on the card.
  bool _isBackdrop(web.Event event) {
    final target = event.target;
    if (target == null) return true;
    return (target as web.Element).closest('.splash-card') == null;
  }

  /// Keeps Tab inside the dialog. There is no other dialog on the site to
  /// borrow this from - the background is not `inert`, so without this a
  /// keyboard visitor tabs straight out into a page they cannot see.
  void _trapTab(web.KeyboardEvent event) {
    final card = _cardKey.currentNode;
    if (card == null) return;
    final focusable = card.querySelectorAll('button, a[href]');
    if (focusable.length == 0) return;
    final first = focusable.item(0) as web.HTMLElement;
    final last = focusable.item(focusable.length - 1) as web.HTMLElement;
    final active = web.document.activeElement;

    if (event.shiftKey && (active == first || active == card)) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && active == last) {
      event.preventDefault();
      first.focus();
    }
  }

  @override
  Component build(BuildContext context) {
    if (_dismissed) return const Component.empty();

    final ctaHref = component.ctaHref;
    final detailHref = component.detailHref;
    final location = component.eventLocation;

    return div(
      classes: 'splash-overlay',
      events: {
        'click': (event) {
          if (_isBackdrop(event)) _close();
        },
        // Element-scoped rather than a document listener: keydown bubbles from
        // the card, and this way there is nothing to unregister.
        'keydown': (event) {
          final key = (event as web.KeyboardEvent).key;
          if (key == 'Escape') {
            _close();
          } else if (key == 'Tab') {
            _trapTab(event);
          }
        },
      },
      [
        div(
          key: _cardKey,
          classes: 'splash-card',
          attributes: const {
            'role': 'dialog',
            'aria-modal': 'true',
            'aria-labelledby': _titleId,
            'tabindex': '-1',
            // Focuses the dialog as the page parses, before the client bundle
            // has loaded. Browsers skip it when the overlay is hidden, which
            // is exactly the returning-visitor case.
            'autofocus': '',
          },
          [
            button(
              classes: 'splash-close',
              type: .button,
              onClick: _close,
              attributes: const {'aria-label': 'Close'},
              [span(attributes: const {'aria-hidden': 'true'}, [.text('×')])],
            ),
            div(classes: 'splash-scroll', [
              img(
                src: sanityImageUrl(component.imageUrl, width: 1200),
                alt: component.imageAlt,
                classes: 'splash-image',
              ),
              div(classes: 'splash-body', [
                h2(id: _titleId, classes: 'splash-title', [.text(component.headline)]),
                p(classes: 'splash-meta', [
                  .text(location == null ? component.dateLine : '${component.dateLine} · $location'),
                ]),
                div(classes: 'splash-actions', [
                  if (ctaHref != null)
                    a(
                      href: ctaHref,
                      target: Target.blank,
                      classes: 'splash-cta',
                      [.text(component.ctaLabel ?? 'Purchase tickets')],
                    ),
                  if (detailHref != null)
                    a(href: detailHref, classes: 'splash-detail', [.text('See event details →')]),
                ]),
              ]),
            ]),
          ],
        ),
      ],
    );
  }
}
