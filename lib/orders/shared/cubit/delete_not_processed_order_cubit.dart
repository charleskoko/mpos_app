import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/domain/not_processed_order.dart';
import '../../core/infrastructure/order_repository.dart';

part 'delete_not_processed_order_state.dart';

class DeleteNotProcessedOrderCubit extends Cubit<DeleteNotProcessedOrderState> {
  final OrderRepository _orderRepository;
  DeleteNotProcessedOrderCubit(this._orderRepository)
      : super(DeleteNotProcessedOrderInitial());

  Future<void> delete(NotProcessedOrder notProcessedOrder) async {
    emit(DeleteNotProcessedOrderLoading());
    final result =
        await _orderRepository.deleteNotProcessedOrder(notProcessedOrder);
    emit(DeleteNotProcessedOrderLoaded());
  }
}
