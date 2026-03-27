import 'package:flutter/material.dart';

class AppLang {
  static const my = Locale("my", "MM");
  static const en = Locale("en", "US");
  static const Map<String, String> supportedLanguages = {
    'en': "English",
    "my": "မြန်မာ"
  };
  static const List<Locale> supportedLocale = [en, my];
  static const localePath = "assets/translations";
}
