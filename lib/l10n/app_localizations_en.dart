// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Louco';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navProfile => 'Profile';

  @override
  String get profileComingSoon => 'Coming soon';

  @override
  String get homeToday => 'Today';

  @override
  String homeInCity(String city) {
    return 'in $city';
  }

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeBuyTicket => 'Buy Ticket';

  @override
  String get homeMoreInfos => 'More Infos';

  @override
  String get homeMarkCalendar => 'Mark your calendar';

  @override
  String get discoverTitle => 'Discover events';

  @override
  String get discoverSearchHint => 'Search events...';

  @override
  String get discoverFilterDate => 'Date';

  @override
  String get discoverFilterCategory => 'Category';

  @override
  String get discoverFilterCity => 'City';

  @override
  String get discoverFreeOnly => 'Free only';

  @override
  String get discoverSort => 'Sort';

  @override
  String discoverResultsFound(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString results found';
  }

  @override
  String get discoverAskAi => 'Ask AI';

  @override
  String get discoverTabEvents => 'Events';

  @override
  String get discoverTabLocations => 'Location';

  @override
  String get discoverResultsFoundSuffix => ' results found';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get homeRetry => 'Retry';

  @override
  String get aiChatFailedTapToResend => 'Failed · Tap to resend';

  @override
  String get aiChatGreeting =>
      'Hey! 👋 I\'m your event assistant. I can help you discover amazing events, find people to go with, or answer any questions about what\'s happening in your city!';

  @override
  String get aiChatTitle => 'Louco AI';

  @override
  String get aiChatSubtitle => 'I\'m your event assistant';

  @override
  String get aiChatInputHint => 'Ask me anything...';

  @override
  String get aiChatSuggestedPromptsLabel => 'Suggested prompts:';

  @override
  String get aiChatPrompt1 => 'What\'s happening in Frankfurt tonight?';

  @override
  String get aiChatPrompt2 => 'Show events near me';

  @override
  String get aiChatPrompt3 => 'Find someone to join me at an event';

  @override
  String get aiChatEventResultsLabel => 'Event Results:';

  @override
  String get aiChatRetry => 'Retry';

  @override
  String get eventDetailsBuyTicket => 'Buy Ticket';

  @override
  String get eventDetailsVenueName => 'Holy Circle';

  @override
  String get eventDetailsVenueAddress =>
      'Mainzer Landstraße 1, 60325 Frankfurt am Main';
}
