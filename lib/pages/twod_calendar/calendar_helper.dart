import 'package:new_lion/data/models/stock_model.dart';

class CalendarHelper {
 static DateTime current = DateTime.now();

 static List<StockModel> list = [];

  static DateTime subtractMonth(DateTime date, int months) {
    // Subtract one month
    int year = date.year;
    int month = date.month - months; // Subtract one month
    int day = date.day;

    // Handle the case where the month becomes less than 1 (e.g., January -> December of the previous year)
    if (month < 1) {
      month = 12; // Set month to December
      year--; // Subtract one year
    }

    // Handle cases where the day is invalid for the new month (e.g., 31st February)
    // Get the last day of the new month
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    return DateTime(year, month, day);
  }

  static DateTime addMonth(DateTime date, int months) {
    // Calculate the new month and year
    int year = date.year;
    int month = date.month + months;

    // Handle month overflow or underflow
    while (month > 12) {
      month -= 12;
      year++;
    }
    while (month < 1) {
      month += 12;
      year--;
    }

    // Handle cases where the day is invalid for the new month (e.g., 31st February)
    // Get the last day of the new month
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    int day = date.day;
    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    return DateTime(year, month, day);
  }

  /// Returns a list of weekday days (Monday to Friday) for the given month.
  static List<int> getWeekdayDays(DateTime month) {
    // Get the list of weekday days (Monday to Friday) for the given month
    List<int> dates = _getWeekdayDaysForMonth(month);

    // Adjust the list to include leading and trailing empty days (0) for grid alignment
    dates = _adjustDatesForGridView(dates, month);

    return dates;
  }

  /// Returns a list of weekday days (Monday to Friday) for the given month.
  static List<int> _getWeekdayDaysForMonth(DateTime month) {
    // List to store the weekday days
    List<int> dates = [];

    // Get the number of days in the month
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    // Iterate through each day of the month
    for (int day = 1; day <= daysInMonth; day++) {
      // Create a DateTime object for the current day
      DateTime date = DateTime(month.year, month.month, day);

      // Check if the day is a weekday (Monday to Friday)
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        // Add the day to the list
        dates.add(day);
      }
    }

    return dates;
  }

  /// Adjusts the list of dates to include leading and trailing empty days (0) for grid alignment.
  static List<int> _adjustDatesForGridView(List<int> dates, DateTime month) {
    // Get the first weekday of the month
    DateTime firstDate = DateTime(month.year, month.month, dates.first);

    // Add leading empty days (0) if the first weekday is not Monday
    if (firstDate.weekday != DateTime.monday) {
      int leadingEmptyDays = firstDate.weekday - DateTime.monday;
      dates.insertAll(0, List.filled(leadingEmptyDays, 0));
    }

    // Add trailing empty days (0) to make the total count 25 (5 rows x 5 columns)
    int totalDays = 25; // 5 rows x 5 columns
    int trailingEmptyDays = totalDays - dates.length;
    if (trailingEmptyDays > 0) {
      dates.addAll(List.filled(trailingEmptyDays, 0));
    }

    return dates;
  }
}
