const siteName = 'The Hagedorn Little Village School';

// Placeholder for the eventual production domain — update once hosting is
// finalized (see CLAUDE.md "Deploy pipeline"). Used to build absolute
// canonical/OG URLs.
const siteBaseUrl = 'https://www.littlevillage.org';

// Kept under ~160 characters: this is the fallback on every page without its
// own, and Google truncates past roughly that. "HLVS" and "autism" are here
// deliberately - the acronym is what families and staff actually search for,
// and autism is around half the student population.
const defaultMetaDescription =
    'The Hagedorn Little Village School (HLVS): special education for children with autism '
    'and developmental delays, birth through 12, on Long Island.';

/// Shortens Sanity body text to a meta-description-friendly length, breaking
/// on a word boundary instead of mid-word.
String truncateForMeta(String text, {int maxLength = 155}) {
  if (text.length <= maxLength) return text;
  final cut = text.substring(0, maxLength);
  final lastSpace = cut.lastIndexOf(' ');
  return '${cut.substring(0, lastSpace > 0 ? lastSpace : maxLength)}…';
}
