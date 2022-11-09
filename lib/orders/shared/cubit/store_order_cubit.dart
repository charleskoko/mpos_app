import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../not_processed_order/core/domain/not_processed_order.dart';
import '../../core/domain/order.dart';
import '../../core/domain/selected_order_item.dart';
import '../../core/infrastructure/order_repository.dart';
part 'store_order_state.dart';

class StoreOrderCubit extends Cubit<StoreOrderState> {
  final OrderRepository _ordeRepository;
  StoreOrderCubit(this._ordeRepository) : super(StoreOrderInitial());

  Future<void> store(
    List<SelectedOrderItem> orderItems, {
    required bool isNotProcessedOrder,
    NotProcessedOrder? notProcessedOrder,
  }) async {
    try {
      emit(StoreOrderLoading());
      Map<String, dynamic> rangedOrderData =
          OrderProduct.rangeOrderData(orderItems);
      final storedOrderOrFailure =
          await _ordeRepository.storeOrderProduct(orderData: rangedOrderData);
      storedOrderOrFailure.fold((orderProduct) {
        emit(
          StoreOrderLoaded(
            orderProduct,
            isNotProcessedOrder: isNotProcessedOrder,
            notProcessedOrder: notProcessedOrder,
          ),
        );
      }, (orderError) {
        emit(
          StoreOrderError(orderError.message),
        );
      });
    } catch (e) {
      emit(
        StoreOrderError(
            'Nous ne parvenons pas à enregistrer cette commande. Veuillez réessayer à nouveau.'),
      );
    }
  }
}
