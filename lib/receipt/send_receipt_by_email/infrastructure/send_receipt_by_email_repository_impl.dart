import 'package:dartz/dartz.dart';
import 'package:mpos_app/receipt/send_receipt_by_email/infrastructure/send_receipt_by_email_remote_service.dart';

import '../../../authentication/domain/authentication_error.dart';
import '../../../core/domain/remote_response.dart';
import '../../../core/infrastructures/network_exception.dart';

class SendReceiptByEmailRepositoryImpl {
  final SendReceiptByEmailRemoteService _sendReceiptByEmailRepository;

  SendReceiptByEmailRepositoryImpl(
    this._sendReceiptByEmailRepository,
  );
  Future<Either<String, AuthenticationError>> sendReceipt(
      Map<String, dynamic> data) async {
    try {
      final sendReceiptRequest = await _sendReceiptByEmailRepository
          .sendReceiptEmail(receiptData: data);
      if (sendReceiptRequest is ConnectionResponse) {
        return left('success');
      } else if (sendReceiptRequest is NotAuthorized) {
        return right(AuthenticationError('notAuthorized'));
      } else {
        return right(AuthenticationError('noConnection'));
      }
    } on RestApiException catch (exception) {
      return right(
        AuthenticationError(exception.message ?? 'noErrorMessage'),
      );
    }
  }
}
