// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Money Counter';

  @override
  String get total => 'Total';

  @override
  String fullBundles(int count) {
    return '$count full bundles';
  }

  @override
  String partialBundles(int count) {
    return '$count partial bundles';
  }

  @override
  String get profiles => 'Profiles';

  @override
  String get activeProfile => 'Active';

  @override
  String get addProfile => 'Add profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get newProfile => 'New profile';

  @override
  String get deleteProfile => 'Delete profile';

  @override
  String confirmDeleteProfile(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get profileName => 'Profile name';

  @override
  String get currencyCode => 'Currency code (e.g. EGP)';

  @override
  String get denominations => 'Denominations';

  @override
  String get addDenomination => 'Add denomination';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String get saveProfile => 'Save profile';

  @override
  String bundleSummaryFull(int bundles, int remainder) {
    return '$bundles bundle + $remainder notes';
  }

  @override
  String bundleSummaryOnly(int bundles) {
    return '$bundles bundle';
  }

  @override
  String notesOnly(int count) {
    return '$count notes';
  }

  @override
  String get addExtraDenomination => 'Add denomination';

  @override
  String get extraDenominationHint =>
      'Emergency — added to current session only';

  @override
  String get denominationValue => 'Value';

  @override
  String get denominationValueHint => 'e.g. 5';

  @override
  String get denominationLabel => 'Label (optional)';

  @override
  String get denominationLabelHint => 'e.g. 5 Pounds';

  @override
  String denominationSubtotal(String amount, String currency) {
    return 'Subtotal: $amount $currency';
  }

  @override
  String get reset => 'Reset';

  @override
  String get resetTitle => 'Reset profile';

  @override
  String get resetConfirm =>
      'All entered values will be cleared. Emergency denominations will remain.';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get saveToHistory => 'Save to history';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get savedToHistory => 'Saved to history';

  @override
  String get history => 'History';

  @override
  String get historyEmpty => 'No history yet';

  @override
  String get historyEmptyHint => 'Save a session to see it here';

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get deleteEntryConfirm => 'Delete this history entry?';

  @override
  String get share => 'Share';

  @override
  String get shareAutoSaveNote => 'Sharing saves automatically to history';

  @override
  String fullBundlesCount(int count) {
    return 'Full bundles: $count';
  }

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'App display language';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get notesInputHint => 'Notes';

  @override
  String get valueMustBePositive => 'Value must be greater than zero';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get currencyRequired => 'Currency code is required';

  @override
  String get atLeastOneDenomination => 'Add at least one denomination';

  @override
  String get denominationAlreadyExists => 'This denomination already exists';

  @override
  String get defaultProfileEGP => 'Egyptian Pound';

  @override
  String get defaultProfileUSD => 'US Dollar';

  @override
  String get extraDenominationTag => 'Emergency';

  @override
  String get switchProfile => 'Switch profile';

  @override
  String get addProfileShort => '+ Profile';

  @override
  String get columnDenomination => 'Denomination';

  @override
  String get columnNotes => 'Notes';

  @override
  String get columnBundles => 'Bundles';

  @override
  String get columnAmount => 'Amount';

  @override
  String get addDenominationTitle => 'Add denomination';

  @override
  String get denominationValueHintShort => 'e.g. 5';

  @override
  String groupSubtotalLabel(String amount, String currency) {
    return 'Subtotal: $amount $currency';
  }

  @override
  String bundleInfoCompact(int bundles) {
    return '($bundles bundle)';
  }

  @override
  String bundleInfoWithRemainder(int bundles, int remainder) {
    return '($bundles+$remainder)';
  }
}
