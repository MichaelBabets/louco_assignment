import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsExt on AppLocalizations {
  List<String> get suggestedPrompts => [
    aiChatPrompt1,
    aiChatPrompt2,
    aiChatPrompt3,
  ];
}
