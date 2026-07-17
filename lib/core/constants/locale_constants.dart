import 'package:flutter/material.dart';

abstract final class LocaleConstants {
  static const english = Locale('en');
  static const spanish = Locale('es');
  static const supportedLocales = [english, spanish];

  static Locale supportedOrEnglish(Locale locale) {
    return locale.languageCode == spanish.languageCode ? spanish : english;
  }
}
