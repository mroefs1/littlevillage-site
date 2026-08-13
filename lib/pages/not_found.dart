import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

// Registered at `/404.html` in app.dart — that literal path (not `/404`) is
// what static hosts (Netlify, Vercel, GitHub Pages) look for by convention
// to serve on an unmatched route, since Jaspr's static build writes routes
// with a file extension straight to that filename instead of nesting an
// `index.html` under it.
class NotFound extends StatelessComponent {
  const NotFound({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'not-found', [
      div(classes: 'not-found-code', [.text('404')]),
      h1([.text("We couldn't find that page")]),
      p(classes: 'not-found-body', [
        .text(
          "The page you're looking for may have moved or no longer exists. "
          "Here are a few places to start instead.",
        ),
      ]),
      Link(to: '/', classes: 'not-found-home-btn', child: .text('Back to Homepage')),
      nav(
        classes: 'not-found-links',
        attributes: const {'aria-label': 'Helpful links'},
        [
          Link(to: '/programs', child: .text('Programs & Enrollment')),
          Link(to: '/admissions', child: .text('Admissions')),
          Link(to: '/about', child: .text('About Us')),
          Link(to: '/news', child: .text('News & Events')),
          Link(to: '/contact', child: .text('Contact')),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.not-found', [
      css('&').styles(
        display: .flex,
        // Left/right in percent (matching the sitewide 10% inset rule) also
        // covers the mobile breakpoint automatically, unlike the old fixed
        // 40px value which had no mobile override at all.
        padding: .only(top: 70.px, left: 10.percent, right: 10.percent, bottom: 90.px),
        flexDirection: .column,
        alignItems: .center,
        textAlign: .center,
      ),
      css('.not-found-code').styles(
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 72.px,
        fontWeight: .w700,
        lineHeight: 1.em,
      ),
      css('h1').styles(
        margin: .only(top: 10.px),
        fontSize: 32.px,
        fontWeight: .w600,
        lineHeight: 1.1.em,
      ),
      css('.not-found-body').styles(
        maxWidth: 480.px,
        margin: .only(top: 14.px),
        color: AppColors.mutedText,
        fontSize: 16.px,
        lineHeight: 1.55.em,
      ),
      css('.not-found-home-btn').styles(
        padding: .symmetric(vertical: 14.px, horizontal: 26.px),
        margin: .only(top: 26.px),
        radius: .all(.circular(Radii.pill)),
        color: Colors.white,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 16.px,
        fontWeight: .w700,
        backgroundColor: AppColors.coral,
      ),
      css('.not-found-links', [
        css('&').styles(
          display: .flex,
          margin: .only(top: 34.px),
          flexWrap: .wrap,
          justifyContent: .center,
          gap: .all(18.px),
        ),
        css('a').styles(
          color: AppColors.blue,
          fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
          fontSize: 14.px,
          fontWeight: .w600,
        ),
        css('a:hover').styles(textDecoration: TextDecoration(line: .underline)),
      ]),
    ]),
  ];
}
