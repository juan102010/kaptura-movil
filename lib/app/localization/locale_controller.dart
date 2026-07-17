import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/locale_constants.dart';

const _localePreferenceKey = 'app_locale';

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
      return LocaleController();
    });

class LocaleController extends StateNotifier<Locale> {
  LocaleController()
    : super(
        LocaleConstants.supportedOrEnglish(PlatformDispatcher.instance.locale),
      ) {
    _restoreLocale();
  }

  Future<void> _restoreLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_localePreferenceKey);
    if (languageCode == null) return;

    state = LocaleConstants.supportedOrEnglish(Locale(languageCode));
  }

  Future<void> setLocale(Locale locale) async {
    final supportedLocale = LocaleConstants.supportedOrEnglish(locale);
    if (state == supportedLocale) return;

    state = supportedLocale;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _localePreferenceKey,
      supportedLocale.languageCode,
    );
  }
}
