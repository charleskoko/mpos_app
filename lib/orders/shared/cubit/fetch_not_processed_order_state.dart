part of 'fetch_not_processed_order_cubit.dart';

@immutable
abstract class FetchNotProcessedOrderState {}

class FetchNotProcessedOrderInitial extends FetchNotProcessedOrderState {}

class FetchNotProcessedOrderLoaded extends FetchNotProcessedOrderState {
  final List<NotProcessedOrder> orders;
  FetchNotProcessedOrderLoaded(this.orders);
}

class FetchNotProcessedOrderLoading extends FetchNotProcessedOrderState {}

class FetchNotProcessedOrderError extends FetchNotProcessedOrderState {
  final String errorMessage;
  FetchNotProcessedOrderError(this.errorMessage);
}
