import 'package:dartz/dartz.dart';
import 'package:mpos_app/orders/core/infrastructure/order_remote_service.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../core/infrastructures/remote_response.dart';
import '../domain/order_error.dart';
import '../domain/order.dart';

class OrderRepository {
  final OrderRemoteService _orderRemoteService;
  OrderRepository(this._orderRemoteService);

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
            'not authorized',
          ),
        );
      } else {
        return right(
          OrderError(
            'no connection',
          ),
        );
      }
    } on RestApiException catch (exception) {
      return right(
        OrderError(exception.message ?? 'no error message'),
      );
    }
  }
}
