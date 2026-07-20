import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/footer.dart';
import 'components/header.dart';
import 'pages/about.dart';
import 'pages/admissions.dart';
import 'pages/board.dart';
import 'pages/contact.dart';
import 'pages/event_detail.dart';
import 'pages/facilities.dart';
import 'pages/founders.dart';
import 'pages/history.dart';
import 'pages/home.dart';
import 'pages/mission.dart';
import 'pages/news_detail.dart';
import 'pages/news_events.dart';
import 'pages/programs.dart';
import 'pages/staff.dart';
import 'sanity/content_repository.dart';

// The root layout shell of the site: header, routed page content, footer.
//
// By using multi-page routing, this component will only be built on the server during pre-rendering and
// **not** executed on the client. Instead only the individual page components are mounted on the client.
//
// Async because news/event detail pages need one concrete `Route` per slug —
// Jaspr's static mode has no `:param` matching at request time, since every
// route must be resolvable up front when the router initializes (see
// docs.jaspr.site/dev/static_sites). The fetched lists are also passed
// straight into the `/news` listing route, so the data is only queried once.
class App extends AsyncStatelessComponent {
  const App({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    // High enough to cover the full history of posts/events, since every one
    // needs its own pre-rendered route, not just the latest page of them.
    final newsPosts = await contentRepository.getNewsPosts(limit: 500);
    final events = await contentRepository.getEvents(limit: 500);

    return div(classes: 'app-shell', [
      const Header(),
      div(classes: 'app-content', [
        Router(routes: [
          Route(path: '/', title: 'Home', builder: (context, state) => const Home()),
          Route(path: '/about', title: 'About', builder: (context, state) => const About()),
          Route(path: '/mission', title: 'Mission Statement', builder: (context, state) => const Mission()),
          Route(path: '/history', title: 'Our History', builder: (context, state) => const OurHistory()),
          Route(path: '/founders', title: 'Founders', builder: (context, state) => const Founders()),
          Route(path: '/staff', title: 'Admin Staff', builder: (context, state) => const Staff()),
          Route(path: '/board', title: 'Board Members', builder: (context, state) => const Board()),
          Route(path: '/facilities', title: 'School Facilities', builder: (context, state) => const Facilities()),
          Route(path: '/programs', title: 'Programs', builder: (context, state) => const Programs()),
          Route(path: '/admissions', title: 'Admissions', builder: (context, state) => const Admissions()),
          Route(
            path: '/news',
            title: 'News & Events',
            builder: (context, state) => NewsEvents(newsPosts: newsPosts, events: events),
          ),
          for (final post in newsPosts)
            if (post.slug != null)
              Route(path: '/news/${post.slug}', title: post.title, builder: (context, state) => NewsDetail(post)),
          for (final event in events)
            if (event.slug != null)
              Route(
                path: '/events/${event.slug}',
                title: event.title,
                builder: (context, state) => EventDetail(event),
              ),
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
