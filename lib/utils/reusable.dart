import 'package:flutter/material.dart';
import 'const.dart';
import 'global.dart';
import '../widgets/zoom_img_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Reusable {
  static showImage(
    BuildContext context,
    List<String> images,
    int selectedIndex,
  ) {
    List<String> urls = images.map((url) {
      return url.startsWith("http") ? url : '${Const.storageURL}/$url';
    }).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZoomImageView(
          //required fields
          images: urls,
          initialIndex: urls.length == 1 ? 0 : selectedIndex,
        ),
      ),
    );
  }

  static Future<void> openURL(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> openURI(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch');
    }
  }

  static List<String> checkKeyword({required String input}) {
    return (Global.config.bannedKeywords ?? [])
        .map((kw) => kw.toLowerCase().replaceAll(" ", ""))
        .where((e) => input.toLowerCase().replaceAll(" ", "").contains(e))
        .toList();
  }

  static formatDateToMyanmar(String dateString) {
    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Get the day of the week (0 = Sunday, 6 = Saturday)
    int weekday = dateTime.weekday;

    // Map English weekdays to Myanmar weekdays
    final List<String> myanmarWeekdays = [
      "တနင်္ဂနွေ", // Sunday
      "တနင်္လာ", // Monday
      "အင်္ဂါ", // Tuesday
      "ဗုဒ္ဓဟူး", // Wednesday
      "ကြာသပတေး", // Thursday
      "သောကြာ", // Friday
      "စနေ", // Saturday
    ];

    // Get the Myanmar weekday
    String myanmarWeekday = myanmarWeekdays[weekday % 7];

    // Extract day, month, and year
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    // Format the result
    return "$day /$month/$year ($myanmarWeekday)";
  }
}
