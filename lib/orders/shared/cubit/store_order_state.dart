part of 'store_order_cubit.dart';

@immutable
abstract class StoreOrderState {}

class StoreOrderInitial extends StoreOrderState {}

class StoreOrderLoading extends StoreOrderState {}

class StoreOrderLoaded extends StoreOrderState {
  final OrderProduct order;
  final bool isNotProcessedOrder;
  final NotProcessedOrder? notProcessedOrder;
  StoreOrderLoaded(
    this.order, {
    this.isNotProcessedOrder = false,
    this.notProcessedOrder,
  });
}

class StoreOrderError extends StoreOrderState {
  final String? message;
  StoreOrderError(this.message);
}
