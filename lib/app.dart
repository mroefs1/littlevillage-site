import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/footer.dart';
import 'components/header.dart';
import 'pages/about.dart';
import 'pages/admissions.dart';
import 'pages/contact.dart';
import 'pages/facilities.dart';
import 'pages/founders.dart';
import 'pages/history.dart';
import 'pages/home.dart';
import 'pages/mission.dart';
import 'pages/news_events.dart';
import 'pages/programs.dart';

// The root layout shell of the site: header, routed page content, footer.
//
// By using multi-page routing, this component will only be built on the server during pre-rendering and
// **not** executed on the client. Instead only the individual page components are mounted on the client.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'app-shell', [
      const Header(),
      div(classes: 'app-content', [
        Router(routes: [
          Route(path: '/', title: 'Home', builder: (context, state) => const Home()),
          Route(path: '/about', title: 'About', builder: (context, state) => const About()),
          Route(path: '/mission', title: 'Mission Statement', builder: (context, state) => const Mission()),
          Route(path: '/history', title: 'Our History', builder: (context, state) => const OurHistory()),
          Route(path: '/founders', title: 'Founders', builder: (context, state) => const Founders()),
          Route(path: '/facilities', title: 'School Facilities', builder: (context, state) => const Facilities()),
          Route(path: '/programs', title: 'Programs', builder: (context, state) => const Programs()),
          Route(path: '/admissions', title: 'Admissions', builder: (context, state) => const Admissions()),
          Route(path: '/news', title: 'News & Events', builder: (context, state) => const NewsEvents()),
          Route(path: '/contact', title: 'Contact', builder: (context, state) => const Contact()),
        ]),
      ]),
      const Footer(),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.app-shell').styles(
      display: .flex,
      minHeight: 100.vh,
      flexDirection: .column,
    ),
    css('.app-content').styles(
      display: .flex,
      flexDirection: .column,
      flex: Flex(grow: 1),
    ),
  ];
}
