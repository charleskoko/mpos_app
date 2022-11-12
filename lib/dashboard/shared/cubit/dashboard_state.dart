part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState {}

class DashboardInfoInitial extends DashboardState {}

class DashboardInfoLoading extends DashboardState {}

class DashboardInfoLoaded extends DashboardState {
  final int numberOfSalesOfThePeriod;
  final int numberOfRefundOfThePeriod;
  final double incomeOftThePeriod;
  final double refundOfThePeriod;
  final String? errorMessage;
  final List<DashboardProductList>? products;

  DashboardInfoLoaded({
    required this.numberOfSalesOfThePeriod,
    required this.numberOfRefundOfThePeriod,
    required this.incomeOftThePeriod,
    required this.refundOfThePeriod,
    required this.products,
    this.errorMessage,
  });
}
