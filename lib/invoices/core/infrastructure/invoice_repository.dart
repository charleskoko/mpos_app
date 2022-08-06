import 'package:dartz/dartz.dart';
import 'package:mpos_app/invoices/core/infrastructure/invoice_remote_service.dart';

import '../../../core/infrastructures/network_exception.dart';
import '../../../core/infrastructures/remote_response.dart';
import '../domain/invoice.dart';
import '../domain/invoice_error.dart';

class InvoiceRepository {
  final InvoiceRemoteService _invoiceRemoteService;
  InvoiceRepository(this._invoiceRemoteService);

  Future<Either<List<Invoice>, InvoiceError>> fetchInvoiceList() async {
    final invoiceListRequestResponse =
        await _invoiceRemoteService.fetchInvoiceList();
    try {
      if (invoiceListRequestResponse is ConnectionResponse) {
        List<Invoice> invoiceList = invoiceListRequestResponse.response;
        return left(invoiceList);
      } else if (invoiceListRequestResponse is NotAuthorized) {
        return right(InvoiceError('not authorized'));
      } else {
        return right(InvoiceError('no connection'));
      }
    } on RestApiException catch (exception) {
      return right(
        InvoiceError(exception.message ?? 'no error message'),
      );
    }
  }
}
