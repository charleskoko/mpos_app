import 'package:dartz/dartz.dart';
import 'package:mpos_app/core/domain/fresh.dart';
import 'package:mpos_app/invoices/core/infrastructure/invoice_local_service.dart';
import 'package:mpos_app/invoices/core/infrastructure/invoice_remote_service.dart';

import '../../../core/infrastructures/network_exception.dart';
import '../../../core/domain/remote_response.dart';
import '../domain/invoice.dart';
import '../domain/invoice_error.dart';

class InvoiceRepository {
  final InvoiceRemoteService _invoiceRemoteService;
  final InvoiceLocalService _invoiceLocalService;
  InvoiceRepository(
    this._invoiceRemoteService,
    this._invoiceLocalService,
  );

  Future<Either<Fresh<List<Invoice>>, InvoiceError>> fetchInvoiceList() async {
    final invoiceListRequestResponse =
        await _invoiceRemoteService.fetchInvoiceList();
    try {
      if (invoiceListRequestResponse is ConnectionResponse) {
        List<Invoice> invoiceList = invoiceListRequestResponse.response;
        await _invoiceLocalService.upsertInvoices(invoiceList);
        return left(Fresh.yes(invoiceList));
      }
      if (invoiceListRequestResponse is NotAuthorized) {
        return right(InvoiceError('not authorized'));
      }
      if (invoiceListRequestResponse is NoConnection) {
        final invoiceList = await _invoiceLocalService.getInvoices();
        return left(Fresh.no(invoiceList));
      }
      return right(InvoiceError('unknown error'));
    } on RestApiException catch (exception) {
      return right(
        InvoiceError(exception.message ?? 'no error message'),
      );
    }
  }
}
