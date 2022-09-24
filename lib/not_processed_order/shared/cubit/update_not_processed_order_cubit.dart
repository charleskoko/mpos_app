import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/domain/not_processed_order.dart';
import '../../../orders/core/infrastructure/order_repository.dart';

part 'update_not_processed_order_state.dart';

class UpdateNotProcessedOrderCubit extends Cubit<UpdateNotProcessedOrderState> {
  final OrderRepository _ordeRepository;
  UpdateNotProcessedOrderCubit(this._ordeRepository)
      : super(UpdateNotProcessedOrderInitial());

  Future<void> updateNotProcessedOrder(NotProcessedOrder order) async {
    emit(UpdateNotProcessedOrderLoading());
    final result = await _ordeRepository.updateNotProcessedOrder(order);
    result.fold(
      (success) => emit(UpdateNotProcessedOrderLoaded()),
      (errorMessage) => emit(UpdateNotProcessedOrderError(errorMessage)),
    );
  }
}
