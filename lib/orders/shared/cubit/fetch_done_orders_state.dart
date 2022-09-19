part of 'fetch_done_orders_cubit.dart';

@immutable
abstract class FetchDoneOrdersState {}

class FetchDoneOrdersInitial extends FetchDoneOrdersState {}

class FetchDoneOrdersLoading extends FetchDoneOrdersState {}

class FetchDoneOrdersLoaded extends FetchDoneOrdersState {
  final Fresh fresh;
  FetchDoneOrdersLoaded(this.fresh);
}

class FetchDoneOrdersError extends FetchDoneOrdersState {
  final String? errorMessage;
  FetchDoneOrdersError(this.errorMessage);
}
