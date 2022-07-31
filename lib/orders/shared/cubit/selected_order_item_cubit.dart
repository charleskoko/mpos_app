import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../products/core/domaine/product.dart';

part 'selected_order_item_state.dart';

class SelectedOrderItemCubit extends Cubit<SelectedOrderItemState> {
  SelectedOrderItemCubit() : super(SelectedOrderItemState());

  Future<void> selectOrderItem(Product product) async {
    List<Product> currentOrderItemsSelected = state.selectedOrderItem ?? [];
    currentOrderItemsSelected.add(product);
    emit(
      SelectedOrderItemState(selectedOrderItem: currentOrderItemsSelected),
    );
  }

  Future<void> cancelCurrentSelection() async {
    emit(
      const SelectedOrderItemState(),
    );
  }
}
