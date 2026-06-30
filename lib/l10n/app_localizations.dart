import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Money Counter'**
  String get appTitle;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @fullBundles.
  ///
  /// In en, this message translates to:
  /// **'{count} full bundles'**
  String fullBundles(int count);

  /// No description provided for @partialBundles.
  ///
  /// In en, this message translates to:
  /// **'{count} partial bundles'**
  String partialBundles(int count);

  /// No description provided for @profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @activeProfile.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeProfile;

  /// No description provided for @addProfile.
  ///
  /// In en, this message translates to:
  /// **'Add profile'**
  String get addProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @newProfile.
  ///
  /// In en, this message translates to:
  /// **'New profile'**
  String get newProfile;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete profile'**
  String get deleteProfile;

  /// No description provided for @confirmDeleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String confirmDeleteProfile(String name);

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get profileName;

  /// No description provided for @currencyCode.
  ///
  /// In en, this message translates to:
  /// **'Currency code (e.g. EGP)'**
  String get currencyCode;

  /// No description provided for @denominations.
  ///
  /// In en, this message translates to:
  /// **'Denominations'**
  String get denominations;

  /// No description provided for @addDenomination.
  ///
  /// In en, this message translates to:
  /// **'Add denomination'**
  String get addDenomination;

  /// No description provided for @dragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragToReorder;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @bundleSummaryFull.
  ///
  /// In en, this message translates to:
  /// **'{bundles} bundle + {remainder} notes'**
  String bundleSummaryFull(int bundles, int remainder);

  /// No description provided for @bundleSummaryOnly.
  ///
  /// In en, this message translates to:
  /// **'{bundles} bundle'**
  String bundleSummaryOnly(int bundles);

  /// No description provided for @notesOnly.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String notesOnly(int count);

  /// No description provided for @addExtraDenomination.
  ///
  /// In en, this message translates to:
  /// **'Add denomination'**
  String get addExtraDenomination;

  /// No description provided for @extraDenominationHint.
  ///
  /// In en, this message translates to:
  /// **'Emergency — added to current session only'**
  String get extraDenominationHint;

  /// No description provided for @denominationValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get denominationValue;

  /// No description provided for @denominationValueHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get denominationValueHint;

  /// No description provided for @denominationLabel.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get denominationLabel;

  /// No description provided for @denominationLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5 Pounds'**
  String get denominationLabelHint;

  /// No description provided for @denominationSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal: {amount} {currency}'**
  String denominationSubtotal(String amount, String currency);

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset profile'**
  String get resetTitle;

  /// No description provided for @resetConfirm.
  ///
  /// In en, this message translates to:
  /// **'All entered values will be cleared. Emergency denominations will remain.'**
  String get resetConfirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @saveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to history'**
  String get saveToHistory;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @savedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Saved to history'**
  String get savedToHistory;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Save a session to see it here'**
  String get historyEmptyHint;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteEntry;

  /// No description provided for @deleteEntryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this history entry?'**
  String get deleteEntryConfirm;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareAutoSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Sharing saves automatically to history'**
  String get shareAutoSaveNote;

  /// No description provided for @fullBundlesCount.
  ///
  /// In en, this message translates to:
  /// **'Full bundles: {count}'**
  String fullBundlesCount(int count);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get languageSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @notesInputHint.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesInputHint;

  /// No description provided for @valueMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Value must be greater than zero'**
  String get valueMustBePositive;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @currencyRequired.
  ///
  /// In en, this message translates to:
  /// **'Currency code is required'**
  String get currencyRequired;

  /// No description provided for @atLeastOneDenomination.
  ///
  /// In en, this message translates to:
  /// **'Add at least one denomination'**
  String get atLeastOneDenomination;

  /// No description provided for @denominationAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This denomination already exists'**
  String get denominationAlreadyExists;

  /// No description provided for @defaultProfileEGP.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Pound'**
  String get defaultProfileEGP;

  /// No description provided for @defaultProfileUSD.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get defaultProfileUSD;

  /// No description provided for @extraDenominationTag.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get extraDenominationTag;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch profile'**
  String get switchProfile;

  /// No description provided for @addProfileShort.
  ///
  /// In en, this message translates to:
  /// **'+ Profile'**
  String get addProfileShort;

  /// No description provided for @columnDenomination.
  ///
  /// In en, this message translates to:
  /// **'Denomination'**
  String get columnDenomination;

  /// No description provided for @columnNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get columnNotes;

  /// No description provided for @columnBundles.
  ///
  /// In en, this message translates to:
  /// **'Bundles'**
  String get columnBundles;

  /// No description provided for @columnAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get columnAmount;

  /// No description provided for @addDenominationTitle.
  ///
  /// In en, this message translates to:
  /// **'Add denomination'**
  String get addDenominationTitle;

  /// No description provided for @denominationValueHintShort.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get denominationValueHintShort;

  /// No description provided for @groupSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal: {amount} {currency}'**
  String groupSubtotalLabel(String amount, String currency);

  /// No description provided for @bundleInfoCompact.
  ///
  /// In en, this message translates to:
  /// **'({bundles} bundle)'**
  String bundleInfoCompact(int bundles);

  /// No description provided for @bundleInfoWithRemainder.
  ///
  /// In en, this message translates to:
  /// **'({bundles}+{remainder})'**
  String bundleInfoWithRemainder(int bundles, int remainder);

  /// No description provided for @aboutCredit.
  ///
  /// In en, this message translates to:
  /// **'Concept & Design: Bahaa Al-Din Muhammad'**
  String get aboutCredit;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 All rights reserved'**
  String get aboutCopyright;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
