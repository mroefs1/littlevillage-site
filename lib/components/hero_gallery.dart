import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../constants/theme.dart';

const _autoScrollInterval = Duration(seconds: 4);
const _resumeAfterInteraction = Duration(seconds: 3);
const _wrapSnapDelay = Duration(milliseconds: 500);

String _itemId(int i) => 'hero-gallery-item-$i';

// Auto-advancing filmstrip. The image list is rendered twice back-to-back
// (the second copy marked `aria-hidden` — screen readers only ever see each
// photo once) so the forward auto-scroll/next-arrow can loop seamlessly:
// once the visually-identical first item of the duplicate copy is reached,
// the scroll position snaps back to the real first item without animating.
//
// Implemented as a `@client` island driving native `Element.scrollTo` on a
// hidden-overflow container, per the Dart-first/minimal-JS constraint — no
// hand-written JS.
@client
class HeroGallery extends StatefulComponent {
  final List<Map<String, String>> images;

  const HeroGallery({required this.images, super.key});

  @override
  State<HeroGallery> createState() => _HeroGalleryState();

  @css
  static List<StyleRule> get styles => [
    css('.hero-gallery').styles(
      display: .block,
      position: .absolute(top: .zero, left: .zero, right: .zero, bottom: .zero),
      radius: .all(.circular(32.px)),
      overflow: .hidden,
    ),
    css('.hero-gallery-track').styles(
      display: .flex,
      height: 100.percent,
      overflow: .hidden,
      gap: .all(12.px),
    ),
    css('.hero-gallery-item').styles(
      display: .flex,
      height: 100.percent,
      flex: Flex(grow: 0, shrink: 0),
    ),
    css('.hero-gallery-photo').styles(
      display: .block,
      width: .auto,
      height: 100.percent,
      raw: {'object-fit': 'cover'},
    ),
    css('.hero-gallery-arrow', [
      css('&').styles(
        display: .flex,
        position: .absolute(top: 50.percent),
        width: 36.px,
        height: 36.px,
        border: .none,
        radius: .all(.circular(18.px)),
        shadow: BoxShadow(offsetX: 0.px, offsetY: 1.px, blur: 4.px, color: .rgba(0, 0, 0, 0.25)),
        transform: .translate(y: (-50).percent),
        justifyContent: .center,
        alignItems: .center,
        color: AppColors.navy,
        fontSize: 20.px,
        backgroundColor: .rgba(255, 255, 255, 0.85),
        raw: {'cursor': 'pointer'},
      ),
      css('&:hover').styles(backgroundColor: Colors.white),
    ]),
    css('.hero-gallery-arrow-prev').styles(position: .absolute(left: 10.px)),
    css('.hero-gallery-arrow-next').styles(position: .absolute(right: 10.px)),
  ];
}

class _HeroGalleryState extends State<HeroGallery> {
  Timer? _autoTimer;
  Timer? _resumeTimer;
  Timer? _snapTimer;
  bool _hovering = false;
  bool _focused = false;
  bool _reducedMotion = false;
  int _index = 0;

  // Hover and focus are tracked separately (rather than one shared flag) —
  // a mouse click also focuses the arrow button in Chrome, so if the mouse
  // then leaves while focus remains, auto-scroll must stay paused for the
  // still-focused keyboard user rather than resuming underneath them.
  bool get _interacting => _hovering || _focused;

  int get _count => component.images.length;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _reducedMotion = web.window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    }
    _startAuto();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _resumeTimer?.cancel();
    _snapTimer?.cancel();
    super.dispose();
  }

  void _startAuto() {
    if (_reducedMotion || _interacting || _count < 2) return;
    _autoTimer ??= Timer.periodic(_autoScrollInterval, (_) => _advance(1, smooth: true));
  }

  void _stopAuto() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void _setHovering(bool value) {
    _hovering = value;
    _syncAuto();
  }

  void _setFocused(bool value) {
    _focused = value;
    _syncAuto();
  }

  void _syncAuto() {
    if (_interacting) {
      _resumeTimer?.cancel();
      _stopAuto();
    } else {
      _startAuto();
    }
  }

  // Arrow clicks pause auto-scroll briefly so the timer doesn't immediately
  // fight the manual navigation, then resume it (unless still hovered/focused).
  void _pauseThenResume() {
    _stopAuto();
    _resumeTimer?.cancel();
    _resumeTimer = Timer(_resumeAfterInteraction, () {
      if (!_interacting) _startAuto();
    });
  }

  void _advance(int direction, {required bool smooth}) {
    if (!kIsWeb || _count == 0) return;
    final next = _index + direction;
    if (next >= _count) {
      // Scroll into the duplicate's first item, then snap back invisibly.
      _scrollToItem(_count, smooth: smooth);
      _snapTimer?.cancel();
      _snapTimer = Timer(_wrapSnapDelay, () {
        _scrollToItem(0, smooth: false);
        _index = 0;
      });
    } else if (next < 0) {
      _scrollToItem(_count - 1, smooth: false);
      _index = _count - 1;
    } else {
      _scrollToItem(next, smooth: smooth);
      _index = next;
    }
  }

  void _scrollToItem(int index, {required bool smooth}) {
    final track = web.document.getElementById('hero-gallery-track');
    final item = web.document.getElementById(_itemId(index));
    if (track == null || item == null) return;
    final trackRect = track.getBoundingClientRect();
    final itemRect = item.getBoundingClientRect();
    final target = track.scrollLeft + (itemRect.left - trackRect.left);
    track.scrollTo(web.ScrollToOptions(left: target, behavior: smooth ? 'smooth' : 'instant'));
  }

  void _onPrev() {
    _pauseThenResume();
    _advance(-1, smooth: true);
  }

  void _onNext() {
    _pauseThenResume();
    _advance(1, smooth: true);
  }

  @override
  Component build(BuildContext context) {
    final images = component.images;
    if (images.isEmpty) {
      return div(classes: 'hero-gallery', []);
    }
    final doubled = [...images, ...images];

    return div(
      classes: 'hero-gallery',
      events: {
        'mouseenter': (_) => _setHovering(true),
        'mouseleave': (_) => _setHovering(false),
        'focusin': (_) => _setFocused(true),
        'focusout': (_) => _setFocused(false),
      },
      [
        div(id: 'hero-gallery-track', classes: 'hero-gallery-track', [
          for (final (i, image) in doubled.indexed)
            div(
              id: _itemId(i),
              classes: 'hero-gallery-item',
              attributes: i >= images.length ? const {'aria-hidden': 'true'} : null,
              [img(src: image['url']!, alt: image['alt'] ?? '', classes: 'hero-gallery-photo')],
            ),
        ]),
        if (images.length > 1) ...[
          button(
            classes: 'hero-gallery-arrow hero-gallery-arrow-prev',
            type: .button,
            onClick: _onPrev,
            attributes: const {'aria-label': 'Previous photo'},
            [
              span(attributes: const {'aria-hidden': 'true'}, [.text('‹')]),
            ],
          ),
          button(
            classes: 'hero-gallery-arrow hero-gallery-arrow-next',
            type: .button,
            onClick: _onNext,
            attributes: const {'aria-label': 'Next photo'},
            [
              span(attributes: const {'aria-hidden': 'true'}, [.text('›')]),
            ],
          ),
        ],
      ],
    );
  }
}
