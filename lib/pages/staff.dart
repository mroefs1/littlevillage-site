import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/collection_card.dart';
import '../components/content_page.dart';
import '../components/seo_meta.dart';
import '../constants/seo.dart';
import '../sanity/content_repository.dart';

class Staff extends AsyncStatelessComponent {
  const Staff({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final staff = await contentRepository.getStaffMembers();

    return .fragment([
      const SeoMeta(
        title: 'Admin Staff | $siteName',
        description: 'Meet the administrative staff at Hagedorn Little Village School.',
        path: '/staff',
      ),
      ContentPage(
        breadcrumb: 'About Us › Admin Staff',
        title: 'Admin Staff',
        children: [
          if (staff.isEmpty)
            p([.text('Staff bios are coming soon.')])
          else
            div(classes: 'card-grid', [
              for (final member in staff)
                CollectionCard(
                  title: member.name,
                  imageUrl: member.photoUrl,
                  imageAlt: 'Staff photo',
                  eyebrow: member.title,
                  excerpt: member.bio,
                ),
            ]),
        ],
      ),
    ]);
  }
}
