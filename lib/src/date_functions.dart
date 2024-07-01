import 'dart:core';

abstract class DateFunctions {
  ///Hijri numbers list
  static const List<String> hijriNumbers = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩'
  ];

  ///get last date of current showed month
  static DateTime getLastDayOfCurrentMonth({required DateTime currentMonth}) {
    DateTime firstDayOfNextMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    return lastDayOfCurrentMonth;
  }

  ///Convert english to hijri n numbers
  static String convertEnglishToHijriNumber(int numbers) {
    String hijriNumber = "";
    '$numbers'.split('').forEach((char) {
      hijriNumber = "$hijriNumber${hijriNumbers[int.parse(char)]}";
    });
    return hijriNumber;
  }
}
