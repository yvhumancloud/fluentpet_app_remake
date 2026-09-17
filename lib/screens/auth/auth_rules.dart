/// The validation rules the six auth screens enforce, and nothing else.
///
/// Pure string arithmetic. It imports nothing — not even Flutter — for the same
/// reason `lib/format/fp_format.dart` does not: a rule about what a password
/// may be is not a widget, and a rule that cannot be read without a
/// `BuildContext` is a rule nobody re-reads.
///
/// **No credential is stored, hashed, sent, compared against anything, or
/// written anywhere.** Every function here takes a string, looks at its shape,
/// and returns a message or null. `AuthRules` is the whole of what these
/// screens do with a password.
///
/// ## The rules, and why each one
///
/// **Email is trimmed. Passwords are not.** Whitespace around an address comes
/// from a paste or an autofill and is never part of it. Whitespace inside a
/// password *is* part of it — a passphrase has spaces — and trimming one would
/// silently change what the user typed, so that a password chosen here could
/// never be typed again. The asymmetry is deliberate and is the single easiest
/// thing on this screen to get wrong.
///
/// **The email check is a shape check, not a validity check.** [emailError]
/// asks whether the string looks like an address; it does not and cannot ask
/// whether anyone reads mail there. A stricter regex is a worse rule, not a
/// better one: RFC 5322 permits addresses that every "validating" regex on the
/// internet rejects, and no regex rejects `nobody@nowhere.example`. The only
/// authority is the mail server, which is why `CHECK_YOUR_EMAIL` says a message
/// *was sent* and never says the account *exists*.
///
/// **One message for every shape failure.** There is no separate message for a
/// missing `@`, a missing dot and a trailing dot. Teaching the user our parser
/// one rejection at a time is worse than telling them once what the field is
/// for.
///
/// **No composition rules.** No required digit, symbol, or capital. NIST
/// SP 800-63B recommends against them explicitly: they push everybody to
/// `Password1!`, which lowers real entropy while looking like it raises it.
/// Length is the only rule here that buys anything, so length is the only rule
/// here. This is the omission most likely to be read as an oversight, so it is
/// written down.
///
/// **Sign-in validates less than sign-up, on purpose.** A returning user's
/// password predates whatever policy is current. Telling them it is "too short"
/// before they have submitted is both untrue and a way of publishing the
/// policy to whoever is holding the phone. [currentPasswordError] therefore
/// only asks whether anything was typed.
library;

/// Every rule the auth screens apply, in one place.
class AuthRules {
  const AuthRules._();

  // ───────────────────────── email ─────────────────────────

  /// The longest address a mail server has to accept: RFC 5321 §4.5.3.1.3
  /// caps the reverse-path and forward-path buffers at 256 octets including
  /// the angle brackets, which leaves 254 for the address.
  ///
  /// Enforced on the field as well as here, so a pathological paste cannot
  /// reach the rule at all.
  static const int emailMaxLength = 254;

  /// The longest local part, RFC 5321 §4.5.3.1.1.
  static const int emailLocalMaxLength = 64;

  /// The one thing an address that is not shaped like an address is told.
  static const String _notAnAddress =
      "That doesn't look like an email address.";

  /// Whitespace removed from both ends, and nothing else changed.
  ///
  /// Case is **not** folded. The domain is case-insensitive and the local part
  /// is not, so lower-casing an address is a change we are not entitled to
  /// make. Anywhere two addresses have to be compared, [sameAddress] does the
  /// folding for the comparison only.
  static String normaliseEmail(String raw) => raw.trim();

  /// Null when [raw] is shaped like an address; the message to show otherwise.
  static String? emailError(String raw) {
    final value = normaliseEmail(raw);
    if (value.isEmpty) return 'Enter your email address.';
    if (value.length > emailMaxLength) {
      return 'An email address cannot be longer than $emailMaxLength '
          'characters.';
    }
    // A space inside an address is legal only inside quotes, which no mail
    // client has produced this century. Rejecting it outright catches the real
    // case: two addresses pasted into one field.
    if (value.contains(RegExp(r'\s'))) return _notAnAddress;

    final at = value.indexOf('@');
    // Not found, first character, or more than one.
    if (at <= 0 || at != value.lastIndexOf('@')) return _notAnAddress;

    final local = value.substring(0, at);
    final domain = value.substring(at + 1);
    if (local.length > emailLocalMaxLength) return _notAnAddress;

    // At least two labels, none of them empty. This rejects `a@b`, `a@b.`,
    // `a@.b` and `a@b..c`, and accepts everything with a real domain.
    final labels = domain.split('.');
    if (labels.length < 2) return _notAnAddress;
    if (labels.any((label) => label.isEmpty)) return _notAnAddress;

    return null;
  }

  /// Whether two addresses are the same one, for comparison only.
  ///
  /// Folds case across the whole address. That is technically wrong for the
  /// local part — RFC 5321 leaves its case-sensitivity to the receiving
  /// server — but every comparison in this app is a warning to the user rather
  /// than an authorisation decision, and a warning that misses because of a
  /// capital letter is the worse failure.
  static bool sameAddress(String a, String b) =>
      normaliseEmail(a).toLowerCase() == normaliseEmail(b).toLowerCase();

  // ───────────────────────── passwords ─────────────────────────

  /// The floor for a password chosen here.
  ///
  /// NIST SP 800-63B sets 8 as the minimum a verifier must allow. 10 is chosen
  /// over 8 for margin: two characters is the cheapest defence this screen can
  /// ask for, and it is still short enough that nobody reaches for a manager to
  /// satisfy it.
  static const int passwordMinLength = 10;

  /// The ceiling.
  ///
  /// NIST asks that at least 64 characters be accepted, so any cap below that
  /// would be a defect. 128 is generous enough to hold any passphrase a person
  /// composes and small enough that pasting a file into the field is not
  /// something the app has to think about. Enforced on the field itself — the
  /// text simply stops — which is why there is no message for it that a user
  /// would normally see.
  static const int passwordMaxLength = 128;

  /// Sign-in's rule: was anything typed.
  ///
  /// Nothing else. See the note at the top of this file on why sign-in
  /// deliberately validates less than sign-up.
  static String? currentPasswordError(String raw) =>
      raw.isEmpty ? 'Enter your password.' : null;

  /// Sign-up's rule.
  ///
  /// [email] is the address the password is being chosen for, when the screen
  /// knows it. It is used for exactly one comparison and is never stored.
  static String? newPasswordError(String raw, {String? email}) {
    if (raw.isEmpty) return 'Choose a password.';
    if (!longEnough(raw)) {
      return 'Use at least $passwordMinLength characters.';
    }
    if (raw.length > passwordMaxLength) {
      return 'Use at most $passwordMaxLength characters.';
    }
    // Checked after the length rule, so a run of ten spaces is told the real
    // problem rather than being told it is too short when it is not.
    if (raw.trim().isEmpty) {
      return 'A password of only spaces is one you will not be able to type '
          'again.';
    }
    if (!notTheAddress(raw, email)) {
      return "Your password cannot be your email address.";
    }
    return null;
  }

  /// Rule one, as a predicate, so the live requirement list can show it
  /// being met rather than only show it being broken.
  static bool longEnough(String raw) => raw.length >= passwordMinLength;

  /// Rule two, as a predicate. True when there is no address to compare
  /// against — an unknown address cannot be the password.
  ///
  /// Matches the whole address and its local part, because `otis@fluent.pet`
  /// and `otis` are the same bad idea.
  static bool notTheAddress(String raw, String? email) {
    final address = email == null ? '' : normaliseEmail(email);
    if (address.isEmpty) return true;
    final candidate = raw.toLowerCase();
    if (candidate == address.toLowerCase()) return false;
    final at = address.indexOf('@');
    if (at > 0 && candidate == address.substring(0, at).toLowerCase()) {
      return false;
    }
    return true;
  }
}
