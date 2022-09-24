part of 'store_not_processed_order_cubit.dart';

@immutable
abstract class StoreNotProcessedOrderState {}

class StoreNotProcessedOrderInitial extends StoreNotProcessedOrderState {}

class StoreNotProcessedOrderLoading extends StoreNotProcessedOrderState {}

class StoreNotProcessedOrderLoaded extends StoreNotProcessedOrderState {}

class StoreNotProcessedOrderError extends StoreNotProcessedOrderState {}
