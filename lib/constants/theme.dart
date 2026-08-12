import 'package:jaspr/dom.dart';

// Design tokens for the Step 11 pastel/Fraunces restyle
// (design_handoff_pastel_redesign/README.md is the source of truth for
// these values). Full replacement of the previous palette — see
// docs/archive/completed-batches.md for the palette this superseded.
class AppColors {
  static const navy = Color('#17334a');
  static const navyDark = Color('#143c55');
  static const navyDarker = Color('#102f43');
  static const blue = Color('#356e8d');
  static const sky = Color('#eaf5f8');
  static const cream = Color('#fffaf2');
  // Not in the README's summary table, but recurs in the reference HTML
  // itself (home.html's news/events section, contact.html's form card) —
  // a near-white card/section background a step past plain white.
  static const offWhite = Color('#f7fafb');
  // The only saturated accent — reserved for CTAs/active states. Darkened
  // from the handoff's literal #ef7d68 during the 11.10 WCAG AA pass: the
  // original failed badly (2.4-2.7:1) both as text-on-white/pastel-card and
  // as the background under white button text, which covers effectively
  // every use of this token (buttons, links, active states) — not a
  // borderline case. This value is calibrated to clear 4.5:1 against every
  // real background it sits on (white, offWhite, sky, peach, mint) and, by
  // the same symmetric math, against white button text too. Hue is
  // essentially unchanged (9.3°→9.4°) — this is a lightness/saturation
  // darken, not a hue shift, and stays visually distinct from the
  // unrelated form-error color (`_dangerColor`, `#b3261e`, hue 3.2°) in
  // contact_form.dart. Same reasoning the pre-Step-11 `accent` color was
  // already darkened for, before this restyle replaced it.
  static const coral = Color('#ce3216');
  static const peach = Color('#fff0e8');
  static const peachDark = Color('#fde3d5');
  static const green = Color('#4e8b75');
  static const mint = Color('#e7f3ed');
  static const mintDark = Color('#d9ecdf');
  static const yellow = Color('#f5c75f');
  static const line = Color('#dce7eb');
  static const lineDark = Color('#cbdbe2');
  static const mutedText = Color('#4e6879');
  static const mutedTextMid = Color('#546b78');
  // Darkened from the handoff's #728591 during the 11.10 WCAG AA pass —
  // the original cleared only 3.4-3.8:1 against its real backgrounds
  // (white/peach/mint/sky), short of the 4.5:1 normal-text floor. This
  // value clears 4.5:1+ against all of them.
  static const mutedTextLight = Color('#5f707a');

  // Not in the README's main token table — taken directly from the
  // reference footer markup (design_handoff_pastel_redesign/home.html),
  // which uses one flat light tone for both footer body text and links.
  static const footerLink = Color('#c6d6df');
  static const footerMuted = Color('#c6d6df');
}

const headingFontFamily = FontFamily('Fraunces');
const bodyFontFamily = FontFamily('DM Sans');

// Shared radius scale from the handoff (card radius 20-28px, pill buttons
// at 999px). Additive in 11.1 — no component consumes these yet; later
// batches adopt them as each page's cards/buttons are restyled.
class Radii {
  static const sm = Unit.pixels(12);
  static const md = Unit.pixels(16);
  static const lg = Unit.pixels(20);
  static const xl = Unit.pixels(24);
  static const xxl = Unit.pixels(28);
  static const pill = Unit.pixels(999);
}

// General-purpose spacing scale calibrated against the handoff (section
// padding ~56-72px, card/row gaps mostly 8-24px). Additive in 11.1 — no
// component consumes these yet.
class Spacing {
  static const xs = Unit.pixels(4);
  static const sm = Unit.pixels(8);
  static const md = Unit.pixels(16);
  static const lg = Unit.pixels(24);
  static const xl = Unit.pixels(32);
  static const xxl = Unit.pixels(48);
  static const section = Unit.pixels(64);
}

// Shared breakpoints for `css.media()` queries across components/pages.
// `tablet` is also where the header nav collapses behind the hamburger
// toggle — the desktop nav (8 items + brand + request-info button) doesn't
// fit inside 1024px once side padding is accounted for.
class Breakpoints {
  static const tablet = Unit.pixels(1024);
  static const mobile = Unit.pixels(768);
  static const small = Unit.pixels(480);
}

@css
List<StyleRule> get globalStyles => [
  css.import(
    'https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&display=swap',
  ),
  css('html, body').styles(
    width: 100.percent,
    minHeight: 100.vh,
    padding: .zero,
    margin: .zero,
    color: AppColors.navy,
    fontFamily: .list([bodyFontFamily, FontFamilies.sansSerif]),
  ),
  css('h1, h2, h3').styles(
    margin: .unset,
    fontFamily: .list([headingFontFamily, FontFamilies.serif]),
    fontWeight: .w700,
  ),
  css('a').styles(
    color: .inherit,
    textDecoration: TextDecoration(line: .none),
  ),
  // Sitewide default focus indicator so every interactive element has a
  // visible, high-contrast state even before a component defines its own
  // (header/footer override this locally where the default blue ring
  // wouldn't have enough contrast against their backgrounds).
  css('a:focus-visible, button:focus-visible').styles(
    radius: .all(.circular(4.px)),
    outline: Outline(color: AppColors.blue, width: OutlineWidth(2.px), style: .solid),
    raw: {'outline-offset': '2px'},
  ),
];
