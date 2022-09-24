import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/domain/not_processed_order.dart';

part 'show_not_processed_order_state.dart';

class ShowNotProcessedOrderCubit extends Cubit<ShowNotProcessedOrderState> {
  ShowNotProcessedOrderCubit() : super(const ShowNotProcessedOrderState());

  Future<void> show(NotProcessedOrder notProcessedOrder) async {
    emit(ShowNotProcessedOrderState(notProcessedOrder: notProcessedOrder));
  }
}
