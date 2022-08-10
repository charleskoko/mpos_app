import 'dart:convert';

import '../../../orders/core/domain/order.dart';
import '../../../orders/core/domain/order_line_item.dart';

class Invoice {
  String? id;
  String? number;
  OrderProduct? order;
  DateTime? createdAt;

  Invoice({
    required this.id,
    required this.number,
    required this.order,
    required this.createdAt,
  });

  Invoice.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    number = jsonObject["number"].toString();
    order = OrderProduct.fromJson(jsonObject["order"]);
    createdAt = DateTime.parse(jsonObject["created_at"].toString()).toLocal();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'created_at': createdAt.toString(),
        'order': order?.toJson()
      };

  String total() {
    double total = 0;
    List<OrderLineItem> orderItem = order?.orderLineItems ?? [];
    for (var item in orderItem) {
      total += item.amount * double.parse('${item.price}');
    }
    return '$total';
  }
}
