import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('th'),
  ];

  static String getTitle(BuildContext context) {
    return Intl.message(
      'Settings',
      name: 'title',
      locale: Localizations.localeOf(context).toString(),
    );
  }

  static String getDefaultCurrency(BuildContext context) {
    return Intl.message(
      'Default Currencies',
      name: 'default_currency',
      locale: Localizations.localeOf(context).toString(),
    );
  }

  static String getLanguage(BuildContext context) {
    return Intl.message(
      'Language',
      name: 'language',
      locale: Localizations.localeOf(context).toString(),
    );
  }

  static String getAppearance(BuildContext context) {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      locale: Localizations.localeOf(context).toString(),
    );
  }

  static String getDarkMode(BuildContext context) {
    return Intl.message(
      'Dark Mode',
      name: 'dark_mode',
      locale: Localizations.localeOf(context).toString(),
    );
  }

  static String getSaveSettings(BuildContext context) {
    return Intl.message(
      'Save Settings',
      name: 'save_settings',
      locale: Localizations.localeOf(context).toString(),
    );
  }
}

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'th'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations());
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
