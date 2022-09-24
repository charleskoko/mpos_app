import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../orders/core/domain/selected_order_item.dart';
import '../../../orders/core/infrastructure/order_repository.dart';

part 'store_not_processed_order_state.dart';

class StoreNotProcessedOrderCubit extends Cubit<StoreNotProcessedOrderState> {
  final OrderRepository orderRepository;
  StoreNotProcessedOrderCubit(this.orderRepository)
      : super(StoreNotProcessedOrderInitial());

  Future<void> store(
      {required String label,
      required List<SelectedOrderItem> orderItems}) async {
    emit(StoreNotProcessedOrderLoading());
    final saveOrFailure =
        await orderRepository.saveNotProcessedOrder(orderItems, label: label);
    saveOrFailure.fold(
      (success) => emit(StoreNotProcessedOrderLoaded()),
      (error) => emit(StoreNotProcessedOrderError()),
    );
  }
}
