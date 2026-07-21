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
    css('.faq-accordion').styles(display: .flex, flexDirection: .column, gap: .all(9.px)),
    css('.faq-item').styles(
      border: .all(color: AppColors.borderLight, width: 2.px),
      radius: .all(.circular(8.px)),
    ),
    css('.faq-question', [
      css('&').styles(
        display: .flex,
        width: 100.percent,
        padding: .symmetric(vertical: 13.px, horizontal: 16.px),
        border: .none,
        justifyContent: .spaceBetween,
        alignItems: .center,
        color: AppColors.ink,
        textAlign: .left,
        fontFamily: .list([headingFontFamily, FontFamilies.cursive]),
        fontSize: 16.px,
        fontWeight: .w700,
        backgroundColor: Colors.transparent,
        raw: {'cursor': 'pointer'},
      ),
    ]),
    css('.faq-icon').styles(color: AppColors.muted, fontSize: 20.px, fontWeight: .w400),
    css('.faq-answer').styles(
      padding: .only(left: 16.px, right: 16.px, bottom: 13.px),
      color: AppColors.body,
      fontSize: 13.px,
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
    return div(classes: 'faq-item${isOpen ? ' open' : ''}', [
      button(
        classes: 'faq-question',
        onClick: () => setState(() => _openIndex = isOpen ? null : i),
        [
          span([.text(item['question']!)]),
          span(classes: 'faq-icon', [.text(isOpen ? '–' : '+')]),
        ],
      ),
      if (isOpen) div(classes: 'faq-answer', [.text(item['answer']!)]),
    ]);
  }
}
