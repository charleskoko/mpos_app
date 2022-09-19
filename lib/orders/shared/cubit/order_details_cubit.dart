import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/domain/order.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit() : super(const OrderDetailsState());

  Future<void> orderDetails(OrderProduct order) async {
    emit(OrderDetailsState(order: order));
  }
}
