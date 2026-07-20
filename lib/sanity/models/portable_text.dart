/// Raw Sanity `blockContent` (portable text) — a stable seam between the
/// data layer and a future portable-text → Jaspr renderer. The existing
/// Flutter app never modeled `page`/`program` (it only has plain-text
/// `body` fields on `news`), so there's no renderer to adapt here yet;
/// rendering these blocks into components is follow-up work.
class PortableText {
  final List<Map<String, dynamic>> blocks;

  const PortableText(this.blocks);

  factory PortableText.fromJson(List<dynamic>? json) {
    return PortableText((json ?? const []).cast<Map<String, dynamic>>());
  }

  bool get isEmpty => blocks.isEmpty;
}
