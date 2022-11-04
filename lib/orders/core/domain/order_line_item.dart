import '../../../products/core/domaine/product.dart';

class OrderLineItem {
  String? id;
  Product? product;
  String? productLabel;
  double price = 0;
  double amount = 0;
  double? total;

  OrderLineItem({
    this.id,
    this.product,
    this.productLabel,
    required this.price,
    required this.amount,
    this.total,
  });

  OrderLineItem.fromJson(Map<String, dynamic> jsonObject) {
    id = jsonObject["id"].toString();
    product = Product.fromJson(jsonObject['product']);
    productLabel = jsonObject['product_label'];
    price = double.parse(jsonObject["price"].toString());
    amount = double.parse(jsonObject['amount'].toString());
    total = price * amount;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product?.toJson(),
        'product_label': productLabel,
        'price': price.toString(),
        'amount': amount.toString(),
      };

  static List<OrderLineItem>? orderLineItemList(List<dynamic> dynamicList) {
    return dynamicList
        .map((element) => OrderLineItem.fromJson(element))
        .toList();
  }
}
