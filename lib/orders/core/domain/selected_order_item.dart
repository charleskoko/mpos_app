import '../../../products/core/domaine/product.dart';

class SelectedOrderItem {
  Product? product;
  String? productLabel;
  double? amount;
  double? price;

  SelectedOrderItem(this.product, this.productLabel, this.amount, this.price);

  SelectedOrderItem.fromJson(Map<String, dynamic> jsonObject) {
    product = Product.fromJson(jsonObject['product']);
    productLabel = jsonObject['product_label'];
    amount = jsonObject['amount'];
    price = jsonObject['price'];
  }

  set setAmount(double amount) {
    this.amount = amount;
  }

  void incrementAmount() {
    amount = amount! + 1;
  }

  void decrementAmount() {
    if (amount! > 1) {
      amount = amount! - 1;
    }
  }

  Map<String, dynamic> toJson() => {
        'product': product?.toJson(),
        'product_label': productLabel,
        'amount': amount,
        'price': price,
      };

  Map<String, dynamic> mapToOrderLineItemBackend() => {
        'product_id': product?.id,
        'product_label': productLabel,
        'amount': amount,
        'price': price,
      };
}
