import 'package:intl/intl.dart';
import 'package:mpos_app/core/shared/extension.dart';

class TimeFormater {
  String dashboardDate(DateTime date) {
    String month = months[date.month - 1];
    int year = date.year;

    return '${date.day} ${months[date.month - 1].substring(0, 3)} ${date.year} ';
  }

  String dashboardDay(DateTime date) {
    return days[date.weekday - 1];
  }

  String dashboardFilterDate(DateTime date) {
    String year = date.year.toString();
    String weekDay = date.weekday.toString();
    String month = date.month.toString();
    return '${(weekDay.length <= 9) ? '0$weekDay' : weekDay}-${(month.length <= 9) ? '0$month' : month}-${year.substring(2, 4)}';
  }

  List<String> days = [
    'lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  List<String> months = [
    'Janvier',
    'Fevrier',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Aout',
    'Septembre',
    'Octobre',
    'Novembre',
    'Decembre'
  ];

  String formatDateForBackend(int day, int? month, int? year) {
    String dayInString = (day <= 9) ? '0$day' : day.toString();
    String monthInString = (month! <= 9) ? '0$month' : month.toString();
    String yearInString = year.toString();

    return '$dayInString-$monthInString-$yearInString';
  }

  String formatDateForOrderDetails(DateTime? date) {
    int? day = date?.day;
    String? month = months[date?.month ?? -1].substring(0, 3);
    int? year = date?.year;

    return '$month $day, $year à ${DateFormat('HH:mm').format(date!)}';
  }

  String formatTransactionDate(String string) {
    DateTime date = DateTime.parse(string.replaceAll(' ', '-'));
    bool isToday = date.isSameDate(DateTime.now());
    bool isYesterday =
        date.isSameDate(DateTime.now().subtract(const Duration(days: 1)));
    bool isbeforeYesterday =
        date.isSameDate(DateTime.now().subtract(const Duration(days: 2)));
    if (isToday) {
      return "aujourd'hui, ${date.day} ${months[date.month - 1]}";
    }
    if (isYesterday) {
      return "hier, ${date.day} ${months[date.month - 1]}";
    }
    if (isbeforeYesterday) {
      return "avant-hier, ${date.day} ${months[date.month - 1]}";
    }
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }
}
