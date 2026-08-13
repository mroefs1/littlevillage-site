const siteName = 'The Hagedorn Little Village School';

// Placeholder for the eventual production domain — update once hosting is
// finalized (see CLAUDE.md "Deploy pipeline"). Used to build absolute
// canonical/OG URLs.
const siteBaseUrl = 'https://www.littlevillage.org';

const defaultMetaDescription =
    'Hagedorn Little Village School provides tuition-free special education, '
    'Early Intervention, preschool, and elementary programs for children with '
    'developmental delays and disabilities on Long Island.';

/// Shortens Sanity body text to a meta-description-friendly length, breaking
/// on a word boundary instead of mid-word.
String truncateForMeta(String text, {int maxLength = 155}) {
  if (text.length <= maxLength) return text;
  final cut = text.substring(0, maxLength);
  final lastSpace = cut.lastIndexOf(' ');
  return '${cut.substring(0, lastSpace > 0 ? lastSpace : maxLength)}…';
}
