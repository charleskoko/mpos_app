import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../products/core/domaine/product.dart';
import '../../core/domain/not_processed_order.dart';
import '../../core/domain/selected_order_item.dart';
part 'selected_order_item_state.dart';

class SelectedOrderItemCubit extends Cubit<SelectedOrderItemState> {
  SelectedOrderItemCubit()
      : super(const SelectedOrderItemState.orderNotCanceled());

  Future<void> selectOrderItem(Product product) async {
    List<SelectedOrderItem>? currentOrderItemsSelected =
        state.selectedOrderItem ?? [];
    if (currentOrderItemsSelected.isEmpty) {
      currentOrderItemsSelected.add(SelectedOrderItem(
        product,
        1,
        product.salePrice,
      ));
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
          selectedOrderItem: currentOrderItemsSelected,
          isNotProcessedOrder: state.isNotProcessedOrder,
          notProcessedOrder: state.notProcessedOrder,
        ),
      );
      return;
    }
  }

  Future<void> cancelCurrentSelection({bool isOrderCanceled = false}) async {
    if (isOrderCanceled) {
      emit(const SelectedOrderItemState.orderCanceled());
    } else {
      emit(const SelectedOrderItemState.orderNotCanceled());
    }
  }

  void updateSelectedItemState(List<SelectedOrderItem> orderItems,
      {bool isNotProcessedOrder = false,
      NotProcessedOrder? notProcessedOrder}) {
    emit(
      SelectedOrderItemState.orderNotCanceled(
        selectedOrderItem: orderItems,
        isNotProcessedOrder: isNotProcessedOrder,
        notProcessedOrder: notProcessedOrder,
      ),
    );
  }

  void removeItemFromList(
      {required SelectedOrderItem itemToDelete,
      required List<SelectedOrderItem> selectedItemList}) {
    selectedItemList
        .removeWhere((item) => item.product?.id == itemToDelete.product?.id);
    emit(
      SelectedOrderItemState.orderNotCanceled(
        selectedOrderItem: selectedItemList,
      ),
    );
  }
}

List<SelectedOrderItem>? _addOrderItemToNotEmptyList(
    List<SelectedOrderItem> currentOrderItemsSelected, Product product) {
  try {
    SelectedOrderItem? currentProductAdded = currentOrderItemsSelected
        .where((orderItem) => orderItem.product?.id == product.id)
        .toList()
        .first;
    currentProductAdded.incrementAmount();
    currentOrderItemsSelected
        .removeWhere((orderItem) => orderItem.product?.id == product.id);

    currentOrderItemsSelected.add(currentProductAdded);

    return currentOrderItemsSelected;
    // ignore: unused_catch_clause
  } on Error catch (e) {
    currentOrderItemsSelected.add(SelectedOrderItem(
      product,
      1,
      product.salePrice,
    ));
    return currentOrderItemsSelected;
  }
}
