import 'order.dart';

class NotProcessedOrder {
  int? id;
  String? label;
  OrderProduct? order;
  DateTime? createdAt;

  NotProcessedOrder({
    required this.label,
    required this.order,
    required this.createdAt,
  });

  NotProcessedOrder.fromJson(Map<String, dynamic> jsonObject) {
    label = jsonObject["label"].toString();
    order = OrderProduct.fromJson(jsonObject["order"]);
    createdAt = DateTime.parse(jsonObject["createdAt"].toString());
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'order': order?.toJson(),
        'createdAt': createdAt.toString,
      };
}
