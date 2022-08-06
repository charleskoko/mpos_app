part of 'fetch_invoice_cubit.dart';

@immutable
abstract class FetchInvoiceState {}

class FetchInvoiceInitial extends FetchInvoiceState {}

class FetchInvoiceLoading extends FetchInvoiceState {}

class FetchInvoiceLoaded extends FetchInvoiceState {
  final List<Invoice> invoices;
  FetchInvoiceLoaded(this.invoices);
}

class FetchInvoiceError extends FetchInvoiceState {
  final String? message;
  FetchInvoiceError(this.message);
}
