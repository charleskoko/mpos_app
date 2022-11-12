import 'package:dartz/dartz.dart';
import 'package:mpos_app/refund/core/infrastructure/refund_remote_service.dart';
import '../../../core/domain/remote_response.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../orders/core/domain/order_error.dart';
import '../domain/refund.dart';
import '../domain/refund_error.dart';

class RefundRepository {
  final RefundRemoteService _refundRemoteService;
  RefundRepository(this._refundRemoteService);

  Future<Either<Refund, RefundError>> storeRefund(
      {required Map<String, dynamic> refund}) async {
    final _refundRequestResponse =
        await _refundRemoteService.store(data: refund);
    try {
      if (_refundRequestResponse is ConnectionResponse) {
        Refund newRefund = _refundRequestResponse.response;
        return left(newRefund);
      } else if (_refundRequestResponse is NotAuthorized) {
        return right(
          RefundError(
            'notAuthorized',
          ),
        );
      } else {
        return right(
          RefundError(
            'noConnection',
          ),
        );
      }
    } on RestApiException catch (exception) {
      return right(
        RefundError(exception.message ?? 'noErrorMessage'),
      );
    }
  }
}
