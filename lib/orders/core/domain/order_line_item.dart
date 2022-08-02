import '../../../products/core/domaine/product.dart';

class OrderLineItem {
  String? id;
  Product? product;
  double? price;
  int? amount;

  OrderLineItem({this.id, this.product, this.price, this.amount});

  OrderLineItem.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    product = Product.fromJson(jsonObject['product']);
    price = double.parse(jsonObject["price"].toString());
    amount = jsonObject['amount'];
  }

  static List<OrderLineItem>? orderLineItemList(List<dynamic> dynamicList) {
    return dynamicList
        .map((element) => OrderLineItem.fromJson(element))
        .toList();
  }

  static Map<String, dynamic> localOrderItem(Product product, int amount) {
    return {
      'product': product,
      'amount': amount,
    };
  }
}
