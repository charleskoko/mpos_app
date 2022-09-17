part of 'calendar_cubit.dart';

class CalendarState {
  final List<CalendarDay>? monthDays;
  final int? month;
  final int? year;
  final String? selectedDate;
  CalendarState({this.monthDays, this.month, this.year, this.selectedDate});
}
