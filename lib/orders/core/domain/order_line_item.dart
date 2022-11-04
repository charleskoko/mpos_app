import '../../../products/core/domaine/product.dart';

class OrderLineItem {
  String? id;
  Product? product;
  double price = 0;
  double amount = 0;
  double? total;

  OrderLineItem({
    this.id,
    this.product,
    required this.price,
    required this.amount,
    this.total,
  });

  OrderLineItem.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    product = Product.fromJson(jsonObject['product']);
    price = double.parse(jsonObject["price"].toString());
    amount = double.parse(jsonObject['amount'].toString());
    total = price * amount;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product?.toJson(),
        'price': price.toString(),
        'amount': amount.toString(),
      };

  static List<OrderLineItem>? orderLineItemList(List<dynamic> dynamicList) {
    return dynamicList
        .map((element) => OrderLineItem.fromJson(element))
        .toList();
  }
}
