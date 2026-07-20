const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Formats a date as e.g. "March 4, 2026". A one-off helper rather than an
/// `intl` dependency, since this is the site's only date-formatting need.
String formatDate(DateTime date) => '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
