import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../products/core/domaine/product.dart';
import '../../core/domain/order_line_item.dart';
part 'selected_order_item_state.dart';

class SelectedOrderItemCubit extends Cubit<SelectedOrderItemState> {
  SelectedOrderItemCubit()
      : super(const SelectedOrderItemState.orderNotCanceled());

  Future<void> selectOrderItem(Product product) async {
    List<Map<String, dynamic>>? currentOrderItemsSelected =
        state.selectedOrderItem ?? [];
    if (currentOrderItemsSelected.isEmpty) {
      currentOrderItemsSelected.add(
        OrderLineItem.localOrderItem(
          product,
          1,
        ),
      );
      emit(
        SelectedOrderItemState.orderNotCanceled(
            selectedOrderItem: currentOrderItemsSelected),
      );
      return;
    }
    if (currentOrderItemsSelected.isNotEmpty) {
      currentOrderItemsSelected =
          _addOrderItemToNotEmptyList(currentOrderItemsSelected, product);
      emit(
        SelectedOrderItemState.orderNotCanceled(
            selectedOrderItem: currentOrderItemsSelected),
      );
      return;
    }
  }

  Future<void> cancelCurrentSelection({bool isOrderCanceled = false}) async {
    if (isOrderCanceled) {
      emit(
        const SelectedOrderItemState.orderCanceled(),
      );
    } else {
      emit(
        const SelectedOrderItemState.orderNotCanceled(),
      );
    }
  }

  void updateSelectedItemState(List<Map<String, dynamic>> orderItems) {
    emit(
      SelectedOrderItemState.orderNotCanceled(selectedOrderItem: orderItems),
    );
  }

  void removeItemFromList(
      {required Map<String, dynamic> itemToDelete,
      required List<Map<String, dynamic>> selectedItemList}) {
    selectedItemList.removeWhere(
        (item) => item['product'].id == itemToDelete['product'].id);
    emit(
      SelectedOrderItemState.orderNotCanceled(
          selectedOrderItem: selectedItemList),
    );
  }
}

List<Map<String, dynamic>>? _addOrderItemToNotEmptyList(
    List<Map<String, dynamic>> currentOrderItemsSelected, Product product) {
  try {
    Map<String, dynamic>? currentProductAdded = currentOrderItemsSelected
        .where((orderItem) => orderItem['product'].id == product.id)
        .toList()
        .first;
    currentProductAdded['amount'] = currentProductAdded['amount'] + 1;
    currentOrderItemsSelected
        .removeWhere((orderItem) => orderItem['product'].id == product.id);

    currentOrderItemsSelected.add(currentProductAdded);

    return currentOrderItemsSelected;
    // ignore: unused_catch_clause
  } on Error catch (e) {
    currentOrderItemsSelected.add(OrderLineItem.localOrderItem(product, 1));
    return currentOrderItemsSelected;
  }
}
