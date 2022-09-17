class CalendarDay {
  final DateTime date;
  final bool thisMonth;
  final bool prevMonth;
  final bool nextMonth;

  CalendarDay({
    required this.date,
    this.thisMonth = false,
    this.prevMonth = false,
    this.nextMonth = false,
  });
}
