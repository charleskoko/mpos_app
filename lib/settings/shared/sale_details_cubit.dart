import 'package:bloc/bloc.dart';

import '../../invoices/core/domain/invoice.dart';

part 'sale_details_state.dart';

class SaleDetailsCubit extends Cubit<SaleDetailsState> {
  SaleDetailsCubit() : super(SaleDetailsState());

  Future<void> show(Invoice invoice) async {
    emit(SaleDetailsState(invoice: invoice));
  }
}
