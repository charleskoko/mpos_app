import 'package:mpos_app/custom_calendar/infrastructures/calendar_service.dart';

import '../domain/calendar_day.dart';

class CalendarRepositoryImpl {
  final CalendarService _calendarService;
  CalendarRepositoryImpl(this._calendarService);
  @override
  List<CalendarDay> month(int month, int year) {
    List<CalendarDay> days = _calendarService.getMonthCalendar(month, year);
    return days;
  }
}
