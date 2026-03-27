import 'package:intl/intl.dart';
import '../../../utils/global.dart';

class LiveHelper {
  static List<String> yrs = [
    for (int i = 2012; i <= DateTime.now().year; i++) i.toString(),
  ];
  static List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String getResult({
    required String? setNum,
    required String? valueNum,
  }) {
    // set -> 1,672.64
    // value -> 33,137.20

    try {
      if (setNum == null || valueNum == null) return '--';
      if (setNum.isEmpty || valueNum.isEmpty) return '--';
      var num1 = setNum.split('').last;
      var num2 = valueNum.split('.')[0].split('').last;
      return '$num1$num2';
    } catch (_) {
      return '--';
    }
  }

  static String? checkOffDay() {
    // Add null safety check
    var todayString = Global.config.today;
    if (todayString == null) {
      return null; // or handle this case appropriately
    }

    DateTime today = DateTime.parse(todayString).toLocal();
    var formattedDate = DateFormat("EEEE d MMM y").format(today);
  
    var holidays = Global.config.setHoliday ?? [];

    // Check if today is weekend (Saturday or Sunday)
    if (today.weekday == DateTime.saturday ||
        today.weekday == DateTime.sunday) {
      return "Weekend: Saturday/Sunday OFF\n($formattedDate)";
    }

    // Check if today is a holiday
    for (final holiday in holidays) {
      // Add null safety check for holiday date
      if (holiday.date == null) continue;

      try {
        final holidayDate = DateFormat(
          "EEEE d MMM y",
        ).format(DateTime.parse(holiday.date!.split("T").first));

        if (holidayDate == formattedDate) {
          return "SET Holiday: ${holiday.description ?? 'Unknown Holiday'} ($formattedDate)";
        }
      } catch (e) {
        // Handle invalid date format gracefully
        continue;
      }
    }

    return null;
  }
}
