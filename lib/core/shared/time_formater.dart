class TimeFormater {
  String dashboardDay(DateTime date) {
    String weekDayInString = days[date.weekday - 1];
    int day = date.day;
    String month = months[date.month - 1];
    int year = date.year;

    return '$weekDayInString, $day $month $year';
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
}
