import 'package:dartz/dartz.dart';
import 'package:mpos_app/orders/core/domain/selected_order_item.dart';
import 'package:mpos_app/orders/core/infrastructure/not_processed_order_local_service.dart';
import 'package:mpos_app/orders/core/infrastructure/order_remote_service.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../core/domain/remote_response.dart';
import '../domain/not_processed_order.dart';
import '../domain/order_error.dart';
import '../domain/order.dart';

class OrderRepository {
  final OrderRemoteService _orderRemoteService;
  NotProcessedOrderLocalservice _notProcessedOrderLocalservice;
  OrderRepository(
      this._orderRemoteService, this._notProcessedOrderLocalservice);

  Future<Either<OrderProduct, OrderError>> storeOrderProduct(
      {required Map<String, dynamic> orderData}) async {
    final storeNewProductRequestresponse =
        await _orderRemoteService.storeNewOrder(orderData);
    try {
      if (storeNewProductRequestresponse is ConnectionResponse) {
        OrderProduct newStoredProduct = storeNewProductRequestresponse.response;
        return left(newStoredProduct);
      } else if (storeNewProductRequestresponse is NotAuthorized) {
        return right(
          OrderError(
            'notAuthorized',
          ),
        );
      } else {
        return right(
          OrderError(
            'noConnection',
          ),
        );
      }
    } on RestApiException catch (exception) {
      return right(
        OrderError(exception.message ?? 'noErrorMessage'),
      );
    }
  }

  Future<Either<int, String>> saveNotProcessedOrder(
      List<SelectedOrderItem> orderItems,
      {required String label}) async {
    try {
      await _notProcessedOrderLocalservice.insert(
        orderLineItems: orderItems,
        label: label,
      );
      return left(1);
    } catch (exception) {
      return right(exception.toString());
    }
  }

  Future<List<NotProcessedOrder>> fetchNotProcessedOrder() async {
    final orderLineItems =
        await _notProcessedOrderLocalservice.getAllOrderSortedByLabel();

    return (orderLineItems);
  }

  Future<Either<int, String>> updateNotProcessedOrder(
      NotProcessedOrder order) async {
    try {
      final result = await _notProcessedOrderLocalservice.update(order);
      return left(result);
    } catch (exception) {
      return right(exception.toString());
    }
  }
}
