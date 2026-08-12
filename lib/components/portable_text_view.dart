import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../sanity/models/portable_text.dart';

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
      result.add(_renderBlock(blocks[i]));
      i++;
    }
    return result;
  }

  static Component _renderBlock(Map<String, dynamic> block) {
    if (block['_type'] == 'image') {
      final url = block['imageUrl'] as String?;
      return url == null ? .fragment([]) : img(src: url, alt: 'Photo');
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
        fontSize: 15.px,
        lineHeight: 1.6.em,
      ),
      css('& h2, & h3, & h4').styles(
        margin: .only(top: 22.px),
        color: AppColors.navy,
      ),
      css('& h2:first-child, & h3:first-child, & h4:first-child').styles(
        margin: .zero,
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
  ];
}
