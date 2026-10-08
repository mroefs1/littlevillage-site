// Fixed external destinations that aren't Sanity-backed, because they're
// infrastructure rather than editable content — the same reasoning that keeps
// the nav array in `header.dart`.

/// Outlook Web Access for staff mailboxes. Rendered in the footer, the About
/// dropdown, and the homepage's Current Families band, so it lives here rather
/// than being written out three times.
const String staffEmailUrl = 'https://mail.littlevillage.org/owa';
