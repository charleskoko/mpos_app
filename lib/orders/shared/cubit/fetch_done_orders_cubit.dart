import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/domain/fresh.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../core/infrastructure/order_repository.dart';

part 'fetch_done_orders_state.dart';

class FetchDoneOrdersCubit extends Cubit<FetchDoneOrdersState> {
  final OrderRepository _orderRepository;
  FetchDoneOrdersCubit(this._orderRepository) : super(FetchDoneOrdersInitial());

  Future<void> fetchDoneOrders() async {
    emit(FetchDoneOrdersLoading());
    try {
      final dayInvoicesOrFailure = await _orderRepository.indexOrderProducts();
      dayInvoicesOrFailure.fold(
        (fresh) => emit(FetchDoneOrdersLoaded(fresh)),
        (orderError) => emit(
          FetchDoneOrdersError(orderError.message),
        ),
      );
    } on RestApiException catch (exception) {}
  }
}
