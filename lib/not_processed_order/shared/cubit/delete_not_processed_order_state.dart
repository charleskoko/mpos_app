part of 'delete_not_processed_order_cubit.dart';

@immutable
abstract class DeleteNotProcessedOrderState {}

class DeleteNotProcessedOrderInitial extends DeleteNotProcessedOrderState {}

class DeleteNotProcessedOrderLoaded extends DeleteNotProcessedOrderState {}

class DeleteNotProcessedOrderLoading extends DeleteNotProcessedOrderState {}

class DeleteNotProcessedOrderError extends DeleteNotProcessedOrderState {}
