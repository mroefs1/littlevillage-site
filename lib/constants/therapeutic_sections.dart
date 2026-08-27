// Anchor targets for the `serviceSection` cards on the Therapeutic Services
// page, so the "Services included" pills on the three program pages (Early
// Intervention, Preschool, Elementary) can deep link straight into the
// matching section — the same pattern as `/current-families#documents`.
//
// Both halves of the link read this one file: `portable_text_view.dart` emits
// the `id` on each card, the program pages build the hrefs. Nothing here is
// stored in Sanity — an anchor id is a link target, not editorial content,
// the same reasoning that keeps the section card colors in Dart.
//
// The ids are curated rather than derived straight from the Sanity titles so
// they stay short and stable (`adaptive-physical-education`, not
// `the-adaptive-physical-education-program`). `anchorForSectionTitle` falls
// back to slugifying the title, so a section added in Sanity later is still
// deep-linkable without a code change.

/// The page every anchor below lives on.
const therapeuticServicesPath = '/programs/therapeutic-services';

class TherapeuticSection {
  /// Must match the Sanity `serviceSection` block's `title` exactly — that's
  /// how the renderer knows which card to put this anchor on. Renaming the
  /// section in Sanity without updating this drops the anchor, and incoming
  /// links land at the top of the page instead (see the build-time warning
  /// in `pages/therapeutic_services.dart`).
  final String title;

  final String anchor;

  const TherapeuticSection({required this.title, required this.anchor});

  /// e.g. `/programs/therapeutic-services#physical-therapy`
  String get link => '$therapeuticServicesPath#$anchor';
}

class TherapeuticSections {
  static const speechLanguage = TherapeuticSection(
    title: 'Speech-Language Therapy',
    anchor: 'speech-language-therapy',
  );
  static const occupationalTherapy = TherapeuticSection(
    title: 'Occupational Therapy',
    anchor: 'occupational-therapy',
  );
  static const physicalTherapy = TherapeuticSection(
    title: 'Physical Therapy',
    anchor: 'physical-therapy',
  );
  static const psychologicalSocialWork = TherapeuticSection(
    title: 'Psychological and Social Work Services',
    anchor: 'psychological-and-social-work',
  );
  static const movementTherapy = TherapeuticSection(
    title: 'Movement Therapy',
    anchor: 'movement-therapy',
  );
  static const adaptivePhysicalEducation = TherapeuticSection(
    title: 'The Adaptive Physical Education Program',
    anchor: 'adaptive-physical-education',
  );
  static const nursing = TherapeuticSection(
    title: 'Nursing Services',
    anchor: 'nursing-services',
  );

  static const all = [
    speechLanguage,
    occupationalTherapy,
    physicalTherapy,
    psychologicalSocialWork,
    movementTherapy,
    adaptivePhysicalEducation,
    nursing,
  ];
}

/// The `id` to render on a `serviceSection` card titled [title]. Returns the
/// curated anchor when the title is one of the known Therapeutic Services
/// sections, otherwise a slug of the title — every card gets an id, wherever
/// it appears (the program pages and Family Services use the same block type),
/// so all of them are linkable. Null for a card with no usable title.
String? anchorForSectionTitle(String title) {
  for (final section in TherapeuticSections.all) {
    if (section.title == title) return section.anchor;
  }
  final slug = _slugify(title);
  return slug.isEmpty ? null : slug;
}

String _slugify(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');
