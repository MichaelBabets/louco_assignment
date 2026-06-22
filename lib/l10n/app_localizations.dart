import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Louco'**
  String get appName;

  /// Bottom navigation home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation search label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// Bottom navigation profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Profile placeholder subtitle
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get profileComingSoon;

  /// Section heading for today's events
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeToday;

  /// City context shown next to 'Today'
  ///
  /// In en, this message translates to:
  /// **'in {city}'**
  String homeInCity(String city);

  /// See-all button label
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeSeeAll;

  /// Buy ticket CTA button
  ///
  /// In en, this message translates to:
  /// **'Buy Ticket'**
  String get homeBuyTicket;

  /// More info CTA button
  ///
  /// In en, this message translates to:
  /// **'More Infos'**
  String get homeMoreInfos;

  /// Calendar action on event details
  ///
  /// In en, this message translates to:
  /// **'Mark your calendar'**
  String get homeMarkCalendar;

  /// Discover page heading
  ///
  /// In en, this message translates to:
  /// **'Discover events'**
  String get discoverTitle;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get discoverSearchHint;

  /// Date filter chip label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get discoverFilterDate;

  /// Category filter chip label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get discoverFilterCategory;

  /// City filter chip label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get discoverFilterCity;

  /// Free-only toggle label
  ///
  /// In en, this message translates to:
  /// **'Free only'**
  String get discoverFreeOnly;

  /// Sort control label
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get discoverSort;

  /// Results count label
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String discoverResultsFound(int count);

  /// Ask AI button label
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get discoverAskAi;

  /// Events tab label on discover page
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get discoverTabEvents;

  /// Locations tab label on discover page
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get discoverTabLocations;

  /// Suffix after the count in results found label
  ///
  /// In en, this message translates to:
  /// **' results found'**
  String get discoverResultsFoundSuffix;

  /// Generic coming soon placeholder
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Retry button on home page error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get homeRetry;

  /// Error label on failed chat message
  ///
  /// In en, this message translates to:
  /// **'Failed · Tap to resend'**
  String get aiChatFailedTapToResend;

  /// Initial AI greeting message shown in chat on open
  ///
  /// In en, this message translates to:
  /// **'Hey! 👋 I\'m your event assistant. I can help you discover amazing events, find people to go with, or answer any questions about what\'s happening in your city!'**
  String get aiChatGreeting;

  /// AI chat assistant name in header
  ///
  /// In en, this message translates to:
  /// **'Louco AI'**
  String get aiChatTitle;

  /// AI chat assistant subtitle in header
  ///
  /// In en, this message translates to:
  /// **'I\'m your event assistant'**
  String get aiChatSubtitle;

  /// Chat text input placeholder
  ///
  /// In en, this message translates to:
  /// **'Ask me anything...'**
  String get aiChatInputHint;

  /// Label above suggested prompt chips
  ///
  /// In en, this message translates to:
  /// **'Suggested prompts:'**
  String get aiChatSuggestedPromptsLabel;

  /// First suggested prompt
  ///
  /// In en, this message translates to:
  /// **'What\'s happening in Frankfurt tonight?'**
  String get aiChatPrompt1;

  /// Second suggested prompt
  ///
  /// In en, this message translates to:
  /// **'Show events near me'**
  String get aiChatPrompt2;

  /// Third suggested prompt
  ///
  /// In en, this message translates to:
  /// **'Find someone to join me at an event'**
  String get aiChatPrompt3;

  /// Heading above AI event results grid
  ///
  /// In en, this message translates to:
  /// **'Event Results:'**
  String get aiChatEventResultsLabel;

  /// Retry button in error banner
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get aiChatRetry;

  /// Buy ticket button on event details page
  ///
  /// In en, this message translates to:
  /// **'Buy Ticket'**
  String get eventDetailsBuyTicket;

  /// Placeholder venue name on event details
  ///
  /// In en, this message translates to:
  /// **'Holy Circle'**
  String get eventDetailsVenueName;

  /// Placeholder venue address on event details
  ///
  /// In en, this message translates to:
  /// **'Mainzer Landstraße 1, 60325 Frankfurt am Main'**
  String get eventDetailsVenueAddress;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
