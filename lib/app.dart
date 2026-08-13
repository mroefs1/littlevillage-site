import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/footer.dart';
import 'components/header.dart';
import 'constants/theme.dart';
import 'pages/about.dart';
import 'pages/admissions.dart';
import 'pages/board.dart';
import 'pages/compliance.dart';
import 'pages/contact.dart';
import 'pages/current_families.dart';
import 'pages/data_privacy_and_security.dart';
import 'pages/early_intervention.dart';
import 'pages/event_detail.dart';
import 'pages/facilities.dart';
import 'pages/founders.dart';
import 'pages/history.dart';
import 'pages/home.dart';
import 'pages/mission.dart';
import 'pages/news_detail.dart';
import 'pages/not_found.dart';
import 'pages/news_events.dart';
import 'pages/parent_association.dart';
import 'pages/program_detail.dart';
import 'pages/programs.dart';
import 'pages/staff.dart';
import 'pages/support_us.dart';
import 'pages/therapeutic_services.dart';
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
    final newsletters = await contentRepository.getNewsletters();
    final programs = await contentRepository.getPrograms();
    final siteSettings = await contentRepository.getSiteSettings();

    return div(classes: 'app-shell', [
      a(href: '#main-content', classes: 'skip-link', [.text('Skip to main content')]),
      Header(programs: programs),
      main_(
        id: 'main-content',
        attributes: const {'tabindex': '-1'},
        classes: 'app-content',
        [
          Router(
            errorBuilder: (context, state) {
              context.setStatusCode(404);
              return const NotFound();
            },
            routes: [
              Route(
                path: '/',
                title: 'Home',
                builder: (context, state) => Home(
                  newsPosts: newsPosts.take(2).toList(),
                  events: events.take(2).toList(),
                  heroGallery: siteSettings.heroGallery,
                  programs: programs,
                ),
              ),
              Route(path: '/about', title: 'About', builder: (context, state) => const About()),
              Route(path: '/mission', title: 'Mission Statement', builder: (context, state) => const Mission()),
              Route(path: '/history', title: 'Our History', builder: (context, state) => const OurHistory()),
              Route(path: '/founders', title: 'Founders', builder: (context, state) => const Founders()),
              Route(path: '/staff', title: 'Admin Staff', builder: (context, state) => const Staff()),
              Route(path: '/board', title: 'Board Members', builder: (context, state) => const Board()),
              Route(path: '/support-us', title: 'Support Us', builder: (context, state) => const SupportUs()),
              Route(path: '/compliance', title: 'Compliance', builder: (context, state) => const Compliance()),
              Route(
                path: '/data-privacy-and-security',
                title: 'Data Privacy and Security',
                builder: (context, state) => const DataPrivacyAndSecurity(),
              ),
              Route(path: '/facilities', title: 'School Facilities', builder: (context, state) => const Facilities()),
              Route(
                path: '/programs',
                title: 'Programs',
                builder: (context, state) => Programs(programs: programs),
              ),
              for (final program in programs)
                Route(
                  path: '/programs/${program.slug}',
                  title: program.title,
                  // Early Intervention has its own redesigned page (Step
                  // 16) - every other program still uses the shared
                  // ProgramDetail template.
                  builder: (context, state) => program.slug == 'early-intervention'
                      ? EarlyIntervention(program)
                      : ProgramDetail(program),
                ),
              Route(
                path: '/programs/therapeutic-services',
                title: 'Therapeutic Services',
                builder: (context, state) => const TherapeuticServices(),
              ),
              Route(path: '/admissions', title: 'Admissions', builder: (context, state) => const Admissions()),
              Route(
                path: '/news',
                title: 'News & Events',
                builder: (context, state) => NewsEvents(newsPosts: newsPosts, events: events, newsletters: newsletters),
              ),
              for (final post in newsPosts)
                if (post.slug != null)
                  Route(
                    path: '/news/${post.slug}',
                    title: post.title,
                    builder: (context, state) => NewsDetail(post),
                    settings: RouteSettings(lastMod: post.publishedDate),
                  ),
              for (final event in events)
                if (event.slug != null)
                  Route(
                    path: '/events/${event.slug}',
                    title: event.title,
                    builder: (context, state) => EventDetail(event),
                    settings: RouteSettings(lastMod: event.publishedDate),
                  ),
              Route(path: '/contact', title: 'Contact', builder: (context, state) => const Contact()),
              Route(
                path: '/current-families',
                title: 'Current Families',
                builder: (context, state) => const CurrentFamilies(),
              ),
              Route(
                path: '/parent-association',
                title: 'Parent Association',
                builder: (context, state) => const ParentAssociation(),
              ),
              // Literal `/404.html` (not `/404`) so the static build writes this
              // route straight to `build/jaspr/404.html` — the filename Netlify,
              // Vercel, and GitHub Pages look for by convention to serve on an
              // unmatched path.
              Route(path: '/404.html', title: 'Page Not Found', builder: (context, state) => const NotFound()),
            ],
          ),
        ],
      ),
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
    // Hidden off-screen until keyboard-focused, so sighted mouse users see
    // nothing extra but keyboard/screen-reader users can jump past the
    // header/nav straight to page content.
    css('.skip-link', [
      css('&').styles(
        position: .absolute(top: (-48).px, left: 8.px),
        padding: .symmetric(vertical: 10.px, horizontal: 16.px),
        radius: .all(.circular(6.px)),
        color: Colors.white,
        fontSize: 14.px,
        fontWeight: .w700,
        backgroundColor: AppColors.blue,
        raw: {'z-index': '100', 'transition': 'top 0.15s ease-in-out'},
      ),
      css('&:focus').styles(
        position: .absolute(top: 8.px, left: 8.px),
      ),
    ]),
  ];
}
