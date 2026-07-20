import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class NewsEvents extends StatelessComponent {
  const NewsEvents({super.key});

  @override
  Component build(BuildContext context) {
    return section([
      h1([.text('News & Events')]),
      p([.text('Content for this page is coming soon.')]),
    ]);
  }
}
