import '../../../products/core/domaine/product.dart';

class OrderLineItem {
  String? id;
  Product? product;
  double price = 0;
  double amount = 0;
  double? total;

  OrderLineItem(
      {this.id,
      this.product,
      required this.price,
      required this.amount,
      this.total});

  OrderLineItem.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    product = Product.fromJson(jsonObject['product']);
    price = double.parse(jsonObject["price"].toString());
    amount = double.parse(jsonObject['amount']);
    print('price: $price, amount: $amount, total: ${price * amount}');
    total = price * amount;
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
