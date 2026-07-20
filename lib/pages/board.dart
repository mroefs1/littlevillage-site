import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/collection_card.dart';
import '../components/content_page.dart';
import '../sanity/content_repository.dart';

class Board extends AsyncStatelessComponent {
  const Board({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final board = await contentRepository.getBoardMembers();

    return ContentPage(
      breadcrumb: 'About Us › Board Members',
      title: 'Board Members',
      children: [
        if (board.isEmpty)
          p([.text('Board member bios are coming soon.')])
        else
          div(classes: 'card-grid', [
            for (final member in board)
              CollectionCard(
                title: member.name,
                imageUrl: member.photoUrl,
                eyebrow: member.title,
                excerpt: member.bio,
              ),
          ]),
      ],
    );
  }
}
