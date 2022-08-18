part of 'selected_order_item_cubit.dart';

@immutable
class SelectedOrderItemState {
  final List<SelectedOrderItem>? selectedOrderItem;
  final bool isOrderCanceled;
  const SelectedOrderItemState.orderNotCanceled({
    this.selectedOrderItem,
  }) : isOrderCanceled = false;
  const SelectedOrderItemState.orderCanceled({
    this.selectedOrderItem,
  }) : isOrderCanceled = true;
}
