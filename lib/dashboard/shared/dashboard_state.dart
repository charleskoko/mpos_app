part of 'dashboard_cubit.dart';

@immutable
class DashboardState {
  final int numberOfSalesOfTheDay;
  final double incomeOftheday;
  final String? errorMessage;
  const DashboardState({
    required this.numberOfSalesOfTheDay,
    required this.incomeOftheday,
    this.errorMessage,
  });
}
