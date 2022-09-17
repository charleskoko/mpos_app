import 'package:bloc/bloc.dart';
import 'package:mpos_app/custom_calendar/infrastructures/calendar_repository_impl.dart';

import '../domain/calendar_day.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepositoryImpl _calendarRepository;
  CalendarCubit(this._calendarRepository) : super(CalendarState());

  void getMonth(int month, int year) {
    List<CalendarDay> monthDays = _calendarRepository.month(month, year);
    monthDays.removeAt(0);
    if (month == DateTime.now().month && year == DateTime.now().year) {
      int indexOfToday = monthDays
          .indexWhere((element) => element.date.day == DateTime.now().day);
      monthDays.removeRange(indexOfToday + 1, monthDays.length);
    }
    emit(
      CalendarState(
        monthDays: monthDays,
        month: month,
        year: year,
      ),
    );
  }
}
