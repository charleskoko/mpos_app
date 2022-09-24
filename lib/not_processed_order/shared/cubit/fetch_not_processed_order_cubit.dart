import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../core/domain/not_processed_order.dart';
import '../../../orders/core/infrastructure/order_repository.dart';
part 'fetch_not_processed_order_state.dart';

class FetchNotProcessedOrderCubit extends Cubit<FetchNotProcessedOrderState> {
  final OrderRepository _ordeRepository;
  FetchNotProcessedOrderCubit(this._ordeRepository)
      : super(FetchNotProcessedOrderInitial());

  Future<void> index({String? id}) async {
    emit(FetchNotProcessedOrderLoading());
    final List<NotProcessedOrder> notProcessedOrderOrFailure =
        await _ordeRepository.fetchNotProcessedOrder();
    notProcessedOrderOrFailure
        .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    if (id?.isEmpty ?? true) {
      emit(FetchNotProcessedOrderLoading());
      emit(FetchNotProcessedOrderLoaded(notProcessedOrderOrFailure));
      return;
    }
    emit(FetchNotProcessedOrderLoading());
    notProcessedOrderOrFailure.removeWhere((element) => element.id == id);
    emit(FetchNotProcessedOrderLoaded(const []));
    emit(FetchNotProcessedOrderLoaded(notProcessedOrderOrFailure));
    return;
  }
}
