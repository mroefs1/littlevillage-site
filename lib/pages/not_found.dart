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
      nav(classes: 'not-found-links', [
        Link(to: '/programs', child: .text('Programs & Enrollment')),
        Link(to: '/admissions', child: .text('Admissions')),
        Link(to: '/about', child: .text('About Us')),
        Link(to: '/news', child: .text('News & Events')),
        Link(to: '/contact', child: .text('Contact')),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.not-found', [
      css('&').styles(
        display: .flex,
        padding: .only(top: 70.px, left: 40.px, right: 40.px, bottom: 90.px),
        flexDirection: .column,
        alignItems: .center,
        textAlign: .center,
      ),
      css('.not-found-code').styles(
        color: AppColors.primary,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 72.px,
        fontWeight: .w700,
        lineHeight: 1.em,
      ),
      css('h1').styles(
        margin: .only(top: 10.px),
        fontSize: 32.px,
        lineHeight: 1.1.em,
      ),
      css('.not-found-body').styles(
        maxWidth: 480.px,
        margin: .only(top: 14.px),
        color: AppColors.body,
        fontSize: 15.px,
        lineHeight: 1.55.em,
      ),
      css('.not-found-home-btn').styles(
        padding: .symmetric(vertical: 13.px, horizontal: 26.px),
        margin: .only(top: 26.px),
        radius: .all(.circular(9.px)),
        color: Colors.white,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 17.px,
        fontWeight: .w700,
        backgroundColor: AppColors.primary,
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
          color: AppColors.primary,
          fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
          fontSize: 14.px,
          fontWeight: .w700,
        ),
        css('a:hover').styles(textDecoration: TextDecoration(line: .underline)),
      ]),
    ]),
  ];
}
