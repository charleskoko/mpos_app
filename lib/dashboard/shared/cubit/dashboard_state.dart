part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState {}

class DashboardInfoInitial extends DashboardState {}

class DashboardInfoLoading extends DashboardState {}

class DashboardInfoLoaded extends DashboardState {
  final int numberOfSalesOfTheDay;
  final double incomeOftheday;
  final String? errorMessage;
  final List<DashboardProductList>? products;
  DashboardInfoLoaded({
    required this.numberOfSalesOfTheDay,
    required this.incomeOftheday,
    required this.products,
    this.errorMessage,
  });
}
