import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension CtxExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isMMLang => locale.languageCode == "my";
  bool get isENLang => locale.languageCode == "en";
  bool get isDarkMode => AdaptiveTheme.of(this).mode.isDark;
  Size get sizer => MediaQuery.of(this).size;
  ThemeData get theme => Theme.of(this);
}

extension DateTimeExtension on DateTime {
  String weekdayName() {
    const Map<int, String> weekdayName = {
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday",
      7: "Sunday",
    };
    return weekdayName[weekday]!;
  }
}

// Extension for num type (covers int and double)
extension SocialCountFormatter on num {
  /// Formats number in Facebook-style (K, M, B)
  /// Example: 1500.toSocialCount() returns "1.5K"
  String toSocialCount() {
    final List<Map<String, dynamic>> units = [
      {'value': 1000000000, 'symbol': 'B'},
      {'value': 1000000, 'symbol': 'M'},
      {'value': 1000, 'symbol': 'K'},
    ];

    for (var unit in units) {
      if (this >= unit['value']) {
        double result = this / unit['value'];
        if (result < 10 && result != result.floor()) {
          return '${result.toStringAsFixed(1)}${unit['symbol']}';
        } else {
          return '${result.floor()}${unit['symbol']}';
        }
      }
    }

    return toString();
  }

  /// Short alias
  String toK() => toSocialCount();
}

extension RandomInt on int {
  static int generate({int min = 0, int max = 9}) {
    final random = Random();
    return min + random.nextInt(max - min);
  }
}