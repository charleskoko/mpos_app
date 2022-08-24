import 'package:mpos_app/orders/core/domain/order_line_item.dart';
import 'package:mpos_app/orders/core/domain/selected_order_item.dart';

class OrderProduct {
  String? id;
  String? number;
  List<OrderLineItem>? orderLineItems;

  OrderProduct({this.id, this.number, this.orderLineItems});

  OrderProduct.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    number = jsonObject["number"].toString();

    orderLineItems =
        OrderLineItem.orderLineItemList(jsonObject['order_line_items']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'order_line_items': orderLineItems?.map((e) => e.toJson()).toList()
      };

  double get getOrderTotalFromListOrderLineItems {
    double orderTotalPrice = 0;
    orderLineItems?.forEach(
      (element) => orderTotalPrice += element.price * element.amount,
    );

    return orderTotalPrice;
  }

  static String getOrderTotalFromMapList(List<SelectedOrderItem> orderItems) {
    double orderPrice = 0;
    for (var element in orderItems) {
      orderPrice += (element.price! * element.amount!);
    }
    return orderPrice.toString();
  }

  static Map<String, dynamic> rangeOrderData(
      List<SelectedOrderItem> orderItems) {
    List<Map<String, dynamic>> orderData = [];
    for (var element in orderItems) {
      orderData.add(element.mapToOrderLineItemBackend());
    }
    return {'addOrderLineItem': orderData};
  }
}
