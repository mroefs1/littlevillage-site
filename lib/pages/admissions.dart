import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Admissions extends StatelessComponent {
  const Admissions({super.key});

  @override
  Component build(BuildContext context) {
    return section([
      h1([.text('Admissions')]),
      p([.text('Content for this page is coming soon.')]),
    ]);
  }
}
