const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

const _monthAbbrs = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

/// Formats a date as e.g. "March 4, 2026". A one-off helper rather than an
/// `intl` dependency, since this is the site's only date-formatting need.
String formatDate(DateTime date) => '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';

/// Formats a date's month as e.g. "MAR", for the date-badge style used on
/// event listings.
String monthAbbr(DateTime date) => _monthAbbrs[date.month - 1];
