import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

// Full build (calendar, documents, quick links) is a later batch — see
// CLAUDE.md's "Current design handoff batches", #7. Stubbed now so the
// homepage's Current Families band and footer link have somewhere to go.
class CurrentFamilies extends StatelessComponent {
  const CurrentFamilies({super.key});

  @override
  Component build(BuildContext context) {
    return section([
      h1([.text('Current Families')]),
      p([.text('Content for this page is coming soon.')]),
    ]);
  }
}
