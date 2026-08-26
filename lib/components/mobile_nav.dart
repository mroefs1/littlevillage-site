import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

// The primary nav, hydrated as one @client boundary so the hamburger toggle
// (mobile/tablet only, <= Breakpoints.nav) has open/closed state. Above
// that breakpoint this renders as the plain always-visible horizontal nav
// with the existing pure-CSS (:hover/:focus-within) Programs/About dropdowns
// — those don't need JS and stay CSS-only even inside this boundary.
//
// Since routing here is full-page navigation (see app.dart: only individual
// page components hydrate, not the header/footer shell), the link data only
// needs to be correct at the moment this page was server-rendered — no
// client-side re-routing concerns. That's what makes it safe to pass nav
// data down as plain Maps (the only shape @client params can take).
@client
class MobileNav extends StatefulComponent {
  final String activePath;
  final List<Map<String, Object?>> items;

  const MobileNav({required this.activePath, required this.items, super.key});

  @override
  State<MobileNav> createState() => _MobileNavState();

  @css
  static List<StyleRule> get styles => [
    css('.nav-toggle').styles(display: .none),
    // Collapsed twice, from the same rules. `Breakpoints.nav` is in `em`, so
    // it already follows the browser's own font-size preference - but a media
    // query cannot see a root font-size set by the accessibility panel, so a
    // visitor who scales text there would keep the desktop row and overflow
    // it. The row needs ~1140px at the default size, so the scaled cases get
    // their own threshold at the worst case (1.25x -> ~1425px), keyed off the
    // presence of `data-text-size`, which is only set when non-default.
    ..._collapsedNav(''),
    ..._collapsedNav('html[data-text-size] '),
  ];

  static List<StyleRule> _collapsedNav(String scope) => [
    css.media(
      MediaQuery.screen(maxWidth: scope.isEmpty ? Breakpoints.nav : const Unit.pixels(1425)),
      [
      css('$scope.nav-toggle', [
        css('&').styles(
          display: .flex,
          width: 40.px,
          height: 40.px,
          border: .none,
          radius: .all(.circular(8.px)),
          justifyContent: .center,
          alignItems: .center,
          color: AppColors.navy,
          fontSize: 1.375.rem,
          backgroundColor: Colors.transparent,
          raw: {'cursor': 'pointer'},
        ),
        css('&:focus-visible').styles(
          outline: Outline(color: AppColors.blue, width: OutlineWidth(2.px), style: .solid),
          raw: {'outline-offset': '2px'},
        ),
      ]),
      css('$scope.primary-nav', [
        css('&').styles(
          display: .none,
          position: .absolute(top: 100.percent, left: 0.px, right: 0.px),
          padding: .all(14.px),
          border: .only(
            bottom: .solid(color: AppColors.line, width: 2.px),
          ),
          shadow: BoxShadow(offsetX: 0.px, offsetY: 8.px, blur: 20.px, color: .rgba(23, 51, 74, 0.14)),
          flexDirection: .column,
          alignItems: .stretch,
          gap: .all(2.px),
          backgroundColor: Colors.white,
          raw: {'z-index': '30'},
        ),
        css('&.open').styles(display: .flex),
      ]),
      // Scoped to `.primary-nav` deliberately, for specificity: header.dart's
      // desktop rule is `header nav .nav-dropdown-menu` (one class, two
      // elements), which outranks a bare `.nav-dropdown-menu` no matter that
      // this sits in a media query — so the intended mobile behaviour (each
      // dropdown's children listed inline in the open flyout) silently never
      // applied, leaving every sub-page unreachable from the mobile menu.
      // Two classes beats one class + two elements.
      css('$scope.primary-nav .nav-dropdown-menu').styles(
        display: .flex,
        position: .relative(top: .zero, left: .zero),
        padding: .zero,
        margin: .only(left: 14.px),
        border: .none,
        shadow: BoxShadow(offsetX: 0.px, offsetY: 0.px, blur: 0.px, color: Colors.transparent),
      ),
      css('$scope.nav-dropdown:hover > .nav-dropdown-menu, $scope.nav-dropdown:focus-within > .nav-dropdown-menu').styles(
        display: .flex,
      ),
      css('$scope.request-info').styles(
        margin: .only(top: 8.px),
        textAlign: .center,
      ),
    ],
    ),
  ];
}

class _MobileNavState extends State<MobileNav> {
  bool _isOpen = false;

  @override
  Component build(BuildContext context) {
    return .fragment([
      button(
        classes: 'nav-toggle',
        onClick: () => setState(() => _isOpen = !_isOpen),
        attributes: {'aria-expanded': '$_isOpen', 'aria-controls': 'primary-nav', 'aria-label': 'Toggle menu'},
        [.text(_isOpen ? '✕' : '☰')],
      ),
      nav(
        id: 'primary-nav',
        classes: 'primary-nav${_isOpen ? ' open' : ''}',
        attributes: const {'aria-label': 'Primary'},
        [
          for (final item in component.items) _navItem(item),
          Link(to: '/contact', classes: 'request-info', child: .text('Contact')),
        ],
      ),
    ]);
  }

  Component _navItem(Map<String, Object?> item) {
    final label = item['label'] as String;
    final path = item['path'] as String;
    final aliases = (item['aliases'] as List?)?.cast<String>() ?? const [];
    final children = (item['children'] as List?)?.cast<Map<String, Object?>>() ?? const [];
    final hasDropdown = children.isNotEmpty;
    final isActive = _isActive(path, aliases);
    final classes = [if (hasDropdown) 'nav-dropdown', if (isActive) 'active'].join(' ');

    return div(classes: classes.isEmpty ? null : classes, [
      Link(
        to: path,
        child: hasDropdown
            ? .fragment([
                .text(label),
                span(classes: 'nav-caret', [.text('▾')]),
              ])
            : .text(label),
      ),
      if (hasDropdown)
        div(classes: 'nav-dropdown-menu', [
          for (final child in children)
            Link(to: child['path'] as String, classes: 'nav-dropdown-link', child: .text(child['label'] as String)),
        ]),
    ]);
  }

  bool _isActive(String path, List<String> aliasPaths) {
    bool matches(String candidate) =>
        component.activePath == candidate || component.activePath.startsWith('$candidate/');
    return matches(path) || aliasPaths.any(matches);
  }
}
