import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/infrastructures/network_exception.dart';
import '../core/domain/invoice.dart';
import '../core/infrastructure/invoice_repository.dart';

part 'fetch_invoice_state.dart';

class FetchInvoiceCubit extends Cubit<FetchInvoiceState> {
  final InvoiceRepository _invoiceRepository;
  FetchInvoiceCubit(this._invoiceRepository) : super(FetchInvoiceInitial());

  Future<void> fetchInvoice() async {
    emit(FetchInvoiceLoading());
    try {
      final fetchTodayInvoiceList = await _invoiceRepository.fetchInvoiceList();
      fetchTodayInvoiceList.fold(
        (invoices) => emit(FetchInvoiceLoaded(invoices)),
        (invoiceError) => emit(FetchInvoiceError(invoiceError.message)),
      );
    } on RestApiException catch (exception) {
      emit(
        FetchInvoiceError(exception.message),
      );
    }
  }
}
