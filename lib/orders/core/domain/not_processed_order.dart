import 'package:intl/intl.dart';
import 'package:mpos_app/orders/core/domain/selected_order_item.dart';

class NotProcessedOrder {
  int? id;
  String? label;
  List<SelectedOrderItem>? selectedOrderItem;
  DateTime? createdAt;

  NotProcessedOrder({
    required this.label,
    required this.selectedOrderItem,
    required this.createdAt,
  });

  NotProcessedOrder.fromJson(Map<String, dynamic> jsonObject) {
    label = jsonObject["label"].toString();
    selectedOrderItem = orderLineItemList(jsonObject["selectedOrderItem"]);
    createdAt = DateTime.parse(jsonObject["createdAt"]);
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'selectedOrderItem':
            selectedOrderItem?.map((element) => element.toJson()).toList(),
        'createdAt':
            DateFormat('yyyy-MM-dd').format(createdAt ?? DateTime.now()),
      };

  static List<SelectedOrderItem>? orderLineItemList(List<dynamic> dynamicList) {
    return dynamicList
        .map((element) => SelectedOrderItem.fromJson(element))
        .toList();
  }
}
