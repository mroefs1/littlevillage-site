import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

// Expand/collapse needs client-side state, so this is the one interactive
// (@client) component on the Admissions page — everything else on that page
// is static. Items are passed in as plain maps since @client parameters must
// be serializable primitives.
@client
class FaqAccordion extends StatefulComponent {
  final List<Map<String, String>> items;
  final int? initialOpenIndex;

  const FaqAccordion({required this.items, this.initialOpenIndex, super.key});

  @override
  State<FaqAccordion> createState() => _FaqAccordionState();

  @css
  static List<StyleRule> get styles => [
    css('.faq-accordion').styles(display: .flex, flexDirection: .column, gap: .all(12.px)),
    css('.faq-item').styles(
      border: .all(color: AppColors.line, width: 1.px),
      radius: .all(.circular(Radii.md)),
    ),
    css('.faq-question', [
      css('&').styles(
        display: .flex,
        width: 100.percent,
        padding: .symmetric(vertical: 16.px, horizontal: 20.px),
        border: .none,
        justifyContent: .spaceBetween,
        alignItems: .center,
        color: AppColors.navy,
        textAlign: .left,
        fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
        fontSize: 15.px,
        fontWeight: .w600,
        backgroundColor: Colors.transparent,
        raw: {'cursor': 'pointer'},
      ),
    ]),
    css('.faq-icon').styles(color: AppColors.coral, fontSize: 18.px, fontWeight: .w700),
    css('.faq-answer').styles(
      padding: .only(left: 20.px, right: 20.px, bottom: 16.px),
      color: AppColors.mutedTextMid,
      fontSize: 14.px,
      lineHeight: 1.5.em,
    ),
  ];
}

class _FaqAccordionState extends State<FaqAccordion> {
  late int? _openIndex = component.initialOpenIndex;

  @override
  Component build(BuildContext context) {
    return div(classes: 'faq-accordion', [
      for (final (i, item) in component.items.indexed) _faqItem(i, item),
    ]);
  }

  Component _faqItem(int i, Map<String, String> item) {
    final isOpen = _openIndex == i;
    final answerId = 'faq-answer-$i';
    return div(classes: 'faq-item${isOpen ? ' open' : ''}', [
      button(
        classes: 'faq-question',
        onClick: () => setState(() => _openIndex = isOpen ? null : i),
        attributes: {'aria-expanded': '$isOpen', 'aria-controls': answerId},
        [
          span([.text(item['question']!)]),
          span(classes: 'faq-icon', attributes: const {'aria-hidden': 'true'}, [.text(isOpen ? '–' : '+')]),
        ],
      ),
      if (isOpen) div(id: answerId, classes: 'faq-answer', [.text(item['answer']!)]),
    ]);
  }
}
