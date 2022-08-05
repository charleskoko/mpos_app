import 'package:mpos_app/orders/core/domain/order_line_item.dart';

class OrderProduct {
  String? id;
  String? number;
  List<OrderLineItem>? orderLineItems;

  OrderProduct({this.id, this.number, this.orderLineItems});

  OrderProduct.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    number = jsonObject["number"].toString();

    orderLineItems =
        OrderLineItem.orderLineItemList(jsonObject['Order_line_items']);
  }

  static String getOrderTotal(List<Map<String, dynamic>> orderItems) {
    double orderPrice = 0;
    orderItems.forEach((element) =>
        orderPrice += element['product'].price * element['amount']);
    return orderPrice.toString();
  }

  static Map<String, dynamic> rangeOrderData(
      List<Map<String, dynamic>> orderItems) {
    List<Map<String, dynamic>> orderData = [];
    orderItems.forEach(
      (element) => orderData.add(
        {
          'product_id': element['product'].id,
          'amount': element['amount'],
          'price': element['amount'] * element['product'].price
        },
      ),
    );
    return {'addOrderLineItem': orderData};
  }
}
