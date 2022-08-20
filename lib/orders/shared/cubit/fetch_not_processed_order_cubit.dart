import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../core/domain/not_processed_order.dart';
import '../../core/infrastructure/order_repository.dart';
part 'fetch_not_processed_order_state.dart';

class FetchNotProcessedOrderCubit extends Cubit<FetchNotProcessedOrderState> {
  final OrderRepository _ordeRepository;
  FetchNotProcessedOrderCubit(this._ordeRepository)
      : super(FetchNotProcessedOrderInitial());

  Future<void> index() async {
    emit(FetchNotProcessedOrderLoading());
    final notProcessedOrderOrFailure =
        await _ordeRepository.fetchNotProcessedOrder();
    emit(FetchNotProcessedOrderLoaded(notProcessedOrderOrFailure));
  }
}
