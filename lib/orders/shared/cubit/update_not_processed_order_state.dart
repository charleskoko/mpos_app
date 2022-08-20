part of 'update_not_processed_order_cubit.dart';

@immutable
abstract class UpdateNotProcessedOrderState {}

class UpdateNotProcessedOrderInitial extends UpdateNotProcessedOrderState {}

class UpdateNotProcessedOrderLoaded extends UpdateNotProcessedOrderState {}

class UpdateNotProcessedOrderLoading extends UpdateNotProcessedOrderState {}

class UpdateNotProcessedOrderError extends UpdateNotProcessedOrderState {
  final String? errorMessage;
  UpdateNotProcessedOrderError(this.errorMessage);
}
