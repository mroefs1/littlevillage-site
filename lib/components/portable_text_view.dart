import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../sanity/models/portable_text.dart';
import 'video_embed.dart';

// Renders Sanity `blockContent` (portable text) into Jaspr markup. Supports
// exactly what the `blockContent` schema allows — block styles (normal,
// h1-h4, blockquote), bullet lists, strong/em decorators, link annotations,
// and inline images (pre-dereferenced to `imageUrl` by the GROQ projection
// in `queries.dart`) — nothing beyond that needs handling.
class PortableTextView extends StatelessComponent {
  final PortableText body;

  const PortableTextView(this.body, {super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'body-content', _renderBlocks(body.blocks));
  }

  static List<Component> _renderBlocks(List<Map<String, dynamic>> blocks) {
    final result = <Component>[];
    var i = 0;
    // Shared across serviceSection and processStep so colors keep cycling
    // rather than each type restarting at the same first color.
    var colorIndex = 0;
    while (i < blocks.length) {
      if (blocks[i]['listItem'] == 'bullet') {
        final items = <Component>[];
        while (i < blocks.length && blocks[i]['listItem'] == 'bullet') {
          items.add(li(_renderSpans(blocks[i])));
          i++;
        }
        result.add(ul(items));
        continue;
      }
      // Consecutive fileDownload blocks group into one card grid, matching
      // the newsletter-download visual pattern (content_page.dart's shared
      // .link-grid/.link-card) rather than stacking as separate rows.
      if (blocks[i]['_type'] == 'fileDownload') {
        final cards = <Component>[];
        while (i < blocks.length && blocks[i]['_type'] == 'fileDownload') {
          cards.add(_fileDownloadCard(blocks[i]));
          i++;
        }
        result.add(div(classes: 'link-grid', cards));
        continue;
      }
      // Consecutive processStep blocks group into one row, same convention
      // as fileDownload above (e.g. a 3-column Referral/Evaluation/Services
      // band), rather than each step stacking as a separate full-width row.
      if (blocks[i]['_type'] == 'processStep') {
        final steps = <Component>[];
        while (i < blocks.length && blocks[i]['_type'] == 'processStep') {
          steps.add(_processStepCard(blocks[i], colorIndex));
          colorIndex++;
          i++;
        }
        result.add(div(classes: 'process-steps', steps));
        continue;
      }
      if (blocks[i]['_type'] == 'serviceSection') {
        result.add(_serviceSectionCard(blocks[i], colorIndex));
        colorIndex++;
        i++;
        continue;
      }
      result.add(_renderBlock(blocks[i]));
      i++;
    }
    return result;
  }

  // Card background cycles through the same pastel tokens used elsewhere
  // for per-item striping (e.g. the homepage age cards, PA dues cards) —
  // the color is assigned here by position, not stored as Sanity content,
  // since it's a presentation concern, not editorial content.
  static const _sectionColors = [
    AppColors.peach,
    AppColors.sky,
    AppColors.mint,
    AppColors.peachDark,
    AppColors.mintDark,
    AppColors.offWhite,
    AppColors.cream,
  ];

  static Component _serviceSectionCard(Map<String, dynamic> block, int index) {
    final title = block['title'] as String? ?? '';
    final body = (block['body'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
    return div(
      classes: 'service-section',
      styles: Styles(backgroundColor: _sectionColors[index % _sectionColors.length]),
      [
        div(classes: 'service-section-title', [.text(title)]),
        ..._renderBlocks(body),
      ],
    );
  }

  static Component _processStepCard(Map<String, dynamic> block, int index) {
    final title = block['title'] as String? ?? '';
    final body = (block['body'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
    return div(
      classes: 'process-step',
      styles: Styles(backgroundColor: _sectionColors[index % _sectionColors.length]),
      [
        div(classes: 'process-step-title', [.text(title)]),
        ..._renderBlocks(body),
      ],
    );
  }

  static Component _fileDownloadCard(Map<String, dynamic> block) {
    final title = block['title'] as String? ?? 'Download';
    final label = block['label'] as String?;
    final fileUrl = block['fileUrl'] as String?;
    // When `label` is set, the source link text itself is the title (e.g.
    // NYSED) — render it as the card's only line rather than a generic
    // title + "Download" pairing.
    final content = label != null
        ? [div(classes: 'link-card-title', [.text(label)])]
        : [
            div(classes: 'link-card-title', [.text(title)]),
            div(classes: 'link-card-cta', [.text('Download →')]),
          ];
    if (fileUrl == null) return div(classes: 'link-card', content);
    return a(href: fileUrl, target: Target.blank, classes: 'link-card', content);
  }

  static Component _renderBlock(Map<String, dynamic> block) {
    if (block['_type'] == 'image') {
      final url = block['imageUrl'] as String?;
      return url == null ? .fragment([]) : img(src: url, alt: 'Photo');
    }
    if (block['_type'] == 'videoEmbed') {
      return VideoEmbed(url: block['url'] as String?, caption: block['caption'] as String?);
    }

    final spans = _renderSpans(block);
    // Every page that renders portable text already has its own `<h1>` from
    // the page template, so an `h1`-styled block is demoted to `h2` here —
    // otherwise an editor picking "Heading 1" in Sanity would produce a
    // second `<h1>` on the page. h2/h3/h4 pass through unchanged since they
    // already nest correctly under the page's real h1.
    switch (block['style'] as String? ?? 'normal') {
      case 'h1':
        return h2(spans);
      case 'h2':
        return h2(spans);
      case 'h3':
        return h3(spans);
      case 'h4':
        return h4(spans);
      case 'blockquote':
        return blockquote(spans);
      default:
        return p(spans);
    }
  }

  static List<Component> _renderSpans(Map<String, dynamic> block) {
    final markDefs = (block['markDefs'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
    final children = (block['children'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();

    return children.map((child) {
      Component node = .text(child['text'] as String? ?? '');
      final marks = (child['marks'] as List<dynamic>? ?? const []).cast<String>();
      for (final mark in marks) {
        final linkDef = _findLinkDef(markDefs, mark);
        if (linkDef != null) {
          node = a(href: linkDef['href'] as String? ?? '#', [node]);
        } else if (mark == 'strong') {
          node = strong([node]);
        } else if (mark == 'em') {
          node = em([node]);
        }
      }
      return node;
    }).toList();
  }

  static Map<String, dynamic>? _findLinkDef(List<Map<String, dynamic>> markDefs, String key) {
    for (final def in markDefs) {
      if (def['_key'] == key && def['_type'] == 'link') return def;
    }
    return null;
  }

  @css
  static List<StyleRule> get styles => [
    css('.body-content', [
      css('&').styles(
        color: AppColors.mutedText,
        fontSize: 0.9375.rem,
        lineHeight: 1.6.em,
      ),
      css('& h2, & h3, & h4').styles(
        margin: .only(top: 22.px),
        color: AppColors.navy,
      ),
      css('& h2:first-child, & h3:first-child, & h4:first-child').styles(
        margin: .zero,
      ),
      // Inline links inside body copy. The sitewide `a` reset in theme.dart
      // is `color: inherit; text-decoration: none`, so without this rule a
      // portable-text link renders identically to the prose around it — not
      // just low-contrast, but with no distinction at all (found 2026-08-25:
      // the Data Privacy page's 10 real hyperlinks were invisible as links).
      // Coral is the established link/CTA color and was contrast-verified in
      // 11.10; the underline carries the distinction without relying on color
      // alone, per WCAG 1.4.1. `.link-card` anchors are excluded — those are
      // whole cards with their own treatment, not inline links.
      css('& a:not(.link-card)').styles(
        color: AppColors.coral,
        textDecoration: TextDecoration(line: .underline),
      ),
      css('p').styles(margin: .only(top: 10.px)),
      css('p:first-child').styles(margin: .zero),
      css('ul').styles(
        padding: .only(left: 20.px),
        margin: .only(top: 10.px),
      ),
      css('li').styles(margin: .only(top: 6.px)),
      css('img').styles(
        maxWidth: 100.percent,
        margin: .only(top: 14.px),
      ),
    ]),
    css('.service-section', [
      css('&').styles(
        padding: .all(32.px),
        margin: .only(top: 20.px),
        radius: .all(.circular(Radii.xxl)),
      ),
      css('.service-section-title').styles(
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.3125.rem,
        fontWeight: .w600,
      ),
    ]),
    css('.process-steps').styles(
      display: .flex,
      margin: .only(top: 20.px),
      flexWrap: .wrap,
      gap: .all(20.px),
    ),
    css('.process-step', [
      css('&').styles(
        padding: .all(28.px),
        radius: .all(.circular(Radii.xxl)),
        flex: Flex(grow: 1, basis: 240.px),
      ),
      css('.process-step-title').styles(
        color: AppColors.navy,
        fontFamily: .list([headingFontFamily, FontFamilies.serif]),
        fontSize: 1.1875.rem,
        fontWeight: .w600,
      ),
    ]),
  ];
}
