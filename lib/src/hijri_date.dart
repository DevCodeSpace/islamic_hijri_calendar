///model class for hijri date datatype to manage date
class HijriDate {
  final String year;
  final String month;
  final String day;

  HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  String toString() {
    return '$day-$month-$year';
  }
}
