part of 'selected_order_item_cubit.dart';

@immutable
class SelectedOrderItemState {
  final List<SelectedOrderItem>? selectedOrderItem;
  final NotProcessedOrder? notProcessedOrder;
  final bool isNotProcessedOrder;
  final bool isOrderCanceled;
  const SelectedOrderItemState.orderNotCanceled({
    this.notProcessedOrder,
    this.selectedOrderItem,
    this.isNotProcessedOrder = false,
  }) : isOrderCanceled = false;
  const SelectedOrderItemState.orderCanceled({
    this.notProcessedOrder,
    this.selectedOrderItem,
    this.isNotProcessedOrder = false,
  }) : isOrderCanceled = true;
}
