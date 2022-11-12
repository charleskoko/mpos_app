part of 'refund_store_cubit.dart';

@immutable
abstract class RefundStoreState {}

class RefundStoreInitial extends RefundStoreState {}

class RefundStoreLoaded extends RefundStoreState {
  final Refund refund;
  RefundStoreLoaded(this.refund);
}

class RefundStoreLoading extends RefundStoreState {}

class RefundStoreError extends RefundStoreState {
  final RefundError error;
  RefundStoreError(this.error);
}
