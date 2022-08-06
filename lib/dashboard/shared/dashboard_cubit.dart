import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:meta/meta.dart';
import 'package:mpos_app/invoices/core/domain/invoice.dart';

import '../../core/infrastructures/network_exception.dart';
import '../../invoices/core/infrastructure/invoice_repository.dart';
import '../../orders/core/domain/order.dart';
import '../../orders/core/domain/order_line_item.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final InvoiceRepository _invoiceRepository;
  DashboardCubit(this._invoiceRepository)
      : super(
          DashboardState(
            incomeOftheday: 0,
            numberOfSalesOfTheDay: 0,
          ),
        );

  Future<void> dashboardData() async {
    try {
      final dayInvoicesOrFailure = await _invoiceRepository.fetchInvoiceList();
      dayInvoicesOrFailure.fold(
        (invoices) {
          int numberOfSalesOfTheDay = invoices.length;
          double incomeOftheday = _getIncomeOfTheDay(invoices);
          emit(DashboardState(
            incomeOftheday: incomeOftheday,
            numberOfSalesOfTheDay: numberOfSalesOfTheDay,
          ));
        },
        (invoiceError) => emit(
          DashboardState(
            incomeOftheday: 0,
            numberOfSalesOfTheDay: 0,
            errorMessage: invoiceError.message,
          ),
        ),
      );
    } on RestApiException catch (exception) {
      emit(
        DashboardState(
          incomeOftheday: 0,
          numberOfSalesOfTheDay: 0,
          errorMessage: exception.message,
        ),
      );
    }
  }

  double _getIncomeOfTheDay(List<Invoice> invoices) {
    double income = 0;
    for (Invoice invoice in invoices) {
      OrderProduct? order = invoice.order;
      List<OrderLineItem>? orderItem = order?.orderLineItems;
      double orderTotal = 0;
      orderItem?.forEach((item) {
        orderTotal +=
            double.parse('${item.amount}') * double.parse('${item.price}');
      });
      income += orderTotal;
    }
    return income;
  }
}
